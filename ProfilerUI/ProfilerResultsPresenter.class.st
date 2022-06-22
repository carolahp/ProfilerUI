"
I am a panel in the ProfilerPresenter containing the profiling process results together with parameters to filter these results
"
Class {
	#name : #ProfilerResultsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'navigationBar',
		'treeTable',
		'summaryText',
		'viewModel',
		'codePresenter',
		'browseButton',
		'treeDropList',
		'expandAllButton',
		'collapseAllButton',
		'thresholdFilterInput',
		'thresholdExpandInput'
	],
	#category : #'ProfilerUI-View'
}

{ #category : #'instance creation' }
ProfilerResultsPresenter class >> withViewModel: aProfilerViewModel [
	^ self basicNew
		viewModel: aProfilerViewModel;
		initialize;
		yourself
]

{ #category : #private }
ProfilerResultsPresenter >> addToolbarItem: anItem [

	| navItem |
	navItem := ProfilerToolbarButtonPresenter new.
	navItem
		object: anItem;
		label: anItem methodName;
		help: 'Display ' , anItem methodName , ' as root';
		action: [ 
			self goInto: anItem.
			self selectToolbarItem: navItem.
			self updateResults.
			navItem node ifNotNil: [ :node | treeTable selectPath: node scrollToSelection: true ]
			 ].

	navigationBar items ifNotEmpty: [ :items | 
		items last node: treeTable selectionMode selectedPath ].
	navigationBar addItem: navItem.
	^ navItem
]

{ #category : #private }
ProfilerResultsPresenter >> browseSelectedItem [ 
	treeTable selectedItem tallyObject method browse
]

{ #category : #private }
ProfilerResultsPresenter >> collapsePath: aPath [
	treeTable
		collapsePath: aPath;
		selectPath: aPath
]

{ #category : #initialization }
ProfilerResultsPresenter >> configurationSectionLayout [

	^ (SpBoxLayout newTopToBottom
			 add: (self newLabel label: 'Configure results display');
			 add: (SpBoxLayout newLeftToRight
					  add: (treeDropList := self newTreeVisualizationDropList);
					  add: (expandAllButton := self newButton label: 'Expand All') width: 100;
					  add: (collapseAllButton := self newButton label: 'Collapse All') width: 100;
					  yourself);
			 add: (SpBoxLayout newLeftToRight
					  add: (self newLabel label: 'Hide nodes under: ') width: 125;
					  add: (thresholdFilterInput := self newThresholdFilterInput) width: 55;
					  add: (self newLabel label: '%') width: 25;
					  yourself);
			 add: (SpBoxLayout newLeftToRight
					  add: (self newLabel label: 'Expand nodes over: ') width: 125;
					  add: (thresholdExpandInput := self newThresholdExpandInput) width: 55;
					  add: (self newLabel label: '%') width: 25; 
					  yourself);
			  yourself)
]

{ #category : #private }
ProfilerResultsPresenter >> expandNodesOver: aNumber [

	| thresholdPercentage |
	thresholdPercentage := aNumber.

	treeTable expandAllSuchThat: [ :item | 
		item weight >= thresholdPercentage ].

	treeTable refresh
]

{ #category : #private }
ProfilerResultsPresenter >> expandPath: aPath [
	treeTable
		expandPath: aPath;
		selectPath: aPath
]

{ #category : #private }
ProfilerResultsPresenter >> goInto [

	| navItem |
	self goInto: treeTable selectedItem.
	self removeToolbarItemsAfter: navigationBar selectedItem.
	navItem := self addToolbarItem: treeTable selectedItem.
	self selectToolbarItem: navItem.
	self updateResults.
	treeTable expandRoots
]

{ #category : #private }
ProfilerResultsPresenter >> goInto: anItem [

	viewModel profilerModel tallyRoot: anItem tallyObject
]

{ #category : #'event handling' }
ProfilerResultsPresenter >> handleArrowLeft [

	self collapsePath: treeTable selection selectedPath
]

{ #category : #'event handling' }
ProfilerResultsPresenter >> handleArrowRight [

	self expandPath: treeTable selection selectedPath
]

{ #category : #'event handling' }
ProfilerResultsPresenter >> handleProfilingFinished [

	| navItem |
	self updateResults.
	viewModel showLeavesOnly ifFalse: [ self selectDoItNode ].
	self updateSummaryText.
	navigationBar removeAllItems.
	navItem := self addToolbarItem: viewModel profilerModel tallyRoot.
	self selectToolbarItem: navItem
]

{ #category : #'event handling' }
ProfilerResultsPresenter >> handleSelectionChange: item [

	item
		ifNil: [ 
			codePresenter text: ''.
			codePresenter beForMethod: nil.
			browseButton disable ]
		ifNotNil: [ 
			| methodOrBlock |
			browseButton enable.
			methodOrBlock := item tallyObject method.
			codePresenter text: methodOrBlock sourceCode.
			codePresenter beForMethod: (methodOrBlock isCompiledBlock
					 ifTrue: [ methodOrBlock method ]
					 ifFalse: [ methodOrBlock ]).
			navigationBar selectedItem ifNotNil: [ :btn | btn node: treeTable selectionMode selectedPath ] ]
]

{ #category : #private }
ProfilerResultsPresenter >> hideNodesUnder: aNumber [ 
	viewModel hideNodesUnder: aNumber.
	self updateResults
]

{ #category : #initialization }
ProfilerResultsPresenter >> initializeActions [

	treeTable whenSelectedItemChangedDo: [ :item | self handleSelectionChange: item ].
	"Code section actions"
	browseButton action: [ self browseSelectedItem ].
	
	"Configuration section actions"
	collapseAllButton action: [ treeTable collapseAll ].

	expandAllButton action: [ treeTable expandAll ].

	thresholdExpandInput whenSubmitDo: [ :text |
		self expandNodesOver: text asNumber ].
	
	thresholdFilterInput whenSubmitDo: [ :text | 
		self hideNodesUnder: text asNumber ].	
	
	treeDropList whenSelectedItemChangedDo: [ :item | 
		viewModel showLeavesOnly: item value.
		self updateResults ]
]

{ #category : #initialization }
ProfilerResultsPresenter >> initializePresenters [

	| h |
	h := self class toolbarHeight.

	self layout: (SpBoxLayout newTopToBottom
			 add: (summaryText := self newLabel label: 'Reporting ') height: h;
			 add: (navigationBar := self newProfilerToolbar) height: h;
			 add: (treeTable := self newTreeTablePresenter);
			 add: self configurationSectionLayout height: h * 3;
			 add: (codePresenter := self newCode beNotEditable);
			 add: (SpBoxLayout newLeftToRight addLast:
						  (browseButton := self newBrowseButton))
			 height: h;
			 yourself).

	self subscribeOnProfilingAnnouncements.
	self initializeActions
]

{ #category : #initialization }
ProfilerResultsPresenter >> menu [

	^ self newMenu
		  title: 'Node menu';
		  addGroup: [ :aGroup | 
			  aGroup
				  addItem: [ :anItem | 
					  anItem
						  name: 'Go into';
						  shortcut: $g meta;
						  description: 'Make node the root of the tree';
						  action: [ self goInto ] ];
				  addItem: [ :anItem | 
					  anItem
						  name: 'Browse method';
						  shortcut: $b meta;
						  description: 'Browse code in Calypso';
						  action: [ self browseSelectedItem ] ] ]
]

{ #category : #initialization }
ProfilerResultsPresenter >> newBrowseButton [

	^ self newButton
		  icon: (self iconNamed: #glamorousBrowse);
		  label: 'Browse';
		  disable;
		  yourself
]

{ #category : #initialization }
ProfilerResultsPresenter >> newProfilerNumberInput [
	^ self instantiate: ProfilerNumberInput 
]

{ #category : #initialization }
ProfilerResultsPresenter >> newProfilerToolbar [

	^ self instantiate: ProfilerToolbarPresenter 
]

{ #category : #initialization }
ProfilerResultsPresenter >> newThresholdExpandInput [

	^ self newProfilerNumberInput
		  help: 'Only nodes with a percentage of time greater than this threshold will be expanded';
		  number: 0;
		  yourself
]

{ #category : #initialization }
ProfilerResultsPresenter >> newThresholdFilterInput [

	^ self newProfilerNumberInput
		  help: 'Only nodes with a percentage of time greater than this threshold will be shown';
		  number: viewModel showNodeThreshold;
		  yourself
]

{ #category : #initialization }
ProfilerResultsPresenter >> newTreeTablePresenter [

	^ self newTreeTable
		  addColumn: ((SpStringTableColumn
				    title: 'Method'
				    evaluated: [ :node | node reportString ])
				   width: 500;
				   yourself);
		  "addColumn:
			  ((SpStringTableColumn title: 'Tally' evaluated: #tally)
				   width: 200;
				   yourself);"
		  "addColumn:
			  (SpLinkTableColumn new
					title: 'Go into';
					width: 70;
					evaluated: [ :node | '->' ];
					action: [ :node | treeTable selectItem: node. self goInto  ];
					yourself);"
		  children: [ :node | | perCent |
				perCent := thresholdFilterInput text asNumber.
				viewModel hideNodesUnder: perCent. 
				(node sonsOver: perCent) asOrderedCollection sort reverse ];
		  bindKeyCombination: Character arrowLeft asKeyCombination
		  toAction: [ self handleArrowLeft ];
		  bindKeyCombination: Character arrowRight asKeyCombination
		  toAction: [ self handleArrowRight ];
		  contextMenu: self menu;
		  "addColumn: (SpLinkTableColumn new
				   title: 'Go';
				   width: 70;
				   evaluated: [ :aNode | '->' ];
				   action: [ :aNode |  attributeTable toggleFilter: aNode variableTag. owner updateHeaderBar. ];
				   sortFunction: #variableTag ascending;
				   yourself);"
			  yourself
]

{ #category : #initialization }
ProfilerResultsPresenter >> newTreeVisualizationDropList [
	| items |
	items := { 
		         ('Full tree' -> false).
		         ('Leaves only' -> true) }.

	^ self newDropList
		                help: 'Results visualization mode';
		                items: items;
		                selectItem: (viewModel showLeavesOnly
				                 ifTrue: [ items at: 2 ]
				                 ifFalse: [ items at: 1 ]);
		                display: [ :assoc | assoc key ];
		                yourself.
]

{ #category : #private }
ProfilerResultsPresenter >> removeToolbarItemsAfter: anItem [
	| toKeep item i |
	toKeep := #() asOrderedCollection.
	i := 1.
	[ 
	item := navigationBar items at: i.
	toKeep add: item.
	i := i + 1.
	item isNotNil and: [ item = anItem ] ] whileFalse.
	navigationBar removeAllItems.
	toKeep do: [ :itm | navigationBar addItem: itm ]
]

{ #category : #private }
ProfilerResultsPresenter >> selectDoItNode [

	| selectorsPath |
	
	selectorsPath := viewModel doItSelectorsPath.
	treeTable expandAllSuchThat: [ :item | 
		(selectorsPath indexOf: item tallyObject method selector) > 0 ].

	[ 
	treeTable
		selectPathOfNodes: selectorsPath
		evaluationBlock: [ :item :selector | 
		item data tallyObject method selector = selector ] ]
		on: SubscriptOutOfBounds
		do: [ "this occurs when the profiled function took too little time" 
			self inform: 'Impossible to display the profiled code. Probably execution time was too short' ]
]

{ #category : #private }
ProfilerResultsPresenter >> selectToolbarItem: anItem [
	| items | 
	navigationBar items do: [:itm | itm icon: nil ].
	anItem icon: (self iconNamed: 'windowMenu').
	
	items := navigationBar items.
	"ugly hack to force the ui refresh"
	navigationBar removeAllItems.
	items do: [ :itm | navigationBar addItem: itm ].
	navigationBar selectedItem: anItem.
	
]

{ #category : #subscription }
ProfilerResultsPresenter >> subscribeOnProfilingAnnouncements [

	viewModel announcer
		when: ProfilingFinishedAnnouncement
		do: [ self handleProfilingFinished ]
]

{ #category : #subscription }
ProfilerResultsPresenter >> unsubscribeFromProfilingAnnouncements [

	viewModel announcer unsubscribe: self
]

{ #category : #update }
ProfilerResultsPresenter >> updateResults [
	
	treeTable roots: viewModel rootItems
]

{ #category : #update }
ProfilerResultsPresenter >> updateSummaryText [

	summaryText label:
		'Reporting - ' , viewModel totalTally asString , ' tallies, '
		, viewModel totalTime asString , ' msec.'
]

{ #category : #accessing }
ProfilerResultsPresenter >> viewModel [

	^ viewModel
]

{ #category : #accessing }
ProfilerResultsPresenter >> viewModel: anObject [

	viewModel := anObject
]

{ #category : #'error signalling' }
ProfilerResultsPresenter >> warning: aString for: aPresenter [

	self newPopover
		addStyle: 'error';
		relativeTo: aPresenter;
		position: SpPopoverPosition top;
		presenter: (SpPresenter new
				 layout: (SpBoxLayout newTopToBottom
						  borderWidth: 2;
						  spacing: 0;
						  add: (self newLabel label: aString);
						  yourself);
				 yourself);
		popup
]
