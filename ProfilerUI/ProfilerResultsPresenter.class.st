"
I am a panel in the ProfilerPresenter containing the profiling process results together with parameters to filter these results
"
Class {
	#name : #ProfilerResultsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'searchInput',
		'navigationBar',
		'treeDropList',
		'treeTable',
		'summaryText',
		'viewModel',
		'codePresenter',
		'browseButton',
		'thresholdExpandInput',
		'thresholdFilterInput'
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

{ #category : #'results display' }
ProfilerResultsPresenter >> expandNodesOver: aNumber [

	| thresholdPercentage |
	thresholdPercentage := aNumber.

	treeTable expandAllSuchThat: [ :item | 
		item weight >= thresholdPercentage ].

	treeTable refresh
]

{ #category : #'filtering nodes' }
ProfilerResultsPresenter >> hideNodesUnder: aNumber [ 
	treeTable roots: (self viewModel rootTallyItemsOver: aNumber).
	treeTable refresh
]

{ #category : #initialization }
ProfilerResultsPresenter >> initializeActions [

	searchInput whenTextChangedDo: [ self error: 'implement me' ].

	treeTable whenSelectedItemChangedDo: [ :item | 
		item
			ifNil: [ 
				codePresenter text: ''.
				codePresenter beForMethod: nil.
				browseButton disable ]
			ifNotNil: [ 
				| methodOrBlock |
				methodOrBlock := item tallyObject method.
				codePresenter text: methodOrBlock sourceCode.
				codePresenter beForMethod: methodOrBlock.
				methodOrBlock isCompiledBlock
					ifTrue: [ browseButton disable ]
					ifFalse: [ browseButton enable ] ] ].

	browseButton action: [ treeTable selectedItem tallyObject method browse ].

	thresholdExpandInput eventHandler
		whenFocusLostDo: [ 
			thresholdExpandInput number isZero ifTrue: [ thresholdExpandInput number: 0.0 ] ];
		whenFocusReceivedDo: [ thresholdExpandInput selectAll ]
]

{ #category : #initialization }
ProfilerResultsPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: summaryText height: self class toolbarHeight;
			 add: searchInput height: self class toolbarHeight;
			 add: navigationBar height: self class toolbarHeight;
			 add: treeTable;
			 add: self newResultsConfigurationPresenter
			 height: self class toolbarHeight * 3;
			 add: codePresenter;
			 add: (SpBoxLayout newLeftToRight addLast: browseButton)
			 height: self class toolbarHeight;
			 yourself)
]

{ #category : #initialization }
ProfilerResultsPresenter >> initializePresenters [

	summaryText := self newLabel label: 'Reporting '.

	searchInput := self newTextInput
		               placeholder: 'Search selector in results';
		               autoAccept: true.

	navigationBar := self newToolbar addItem:
		                 (SpToolbarButtonPresenter new
			                  label: 'Root';
			                  help: 'Root of the execution tree';
			                  action: [ self inform: 'Root!' ]).
	treeTable := self newTreeTablePresenter.

	codePresenter := self newCode beNotEditable.

	browseButton := self newButton
		                icon: (self iconNamed: #glamorousBrowse);
		                label: 'Browse';
		                disable;
		                yourself.

	self initializeLayout.
	self subscribeOnProfilingAnnouncements.
	self initializeActions
]

{ #category : #accessing }
ProfilerResultsPresenter >> navigationBar [

	^ navigationBar
]

{ #category : #initialization }
ProfilerResultsPresenter >> newResultsConfigurationPresenter [

	| applyCustomExpandButton collapseAllButton expandAllButton filterNodesButton |
	"Presenters"
	treeDropList := self newDropList
		                help: 'Results visualization mode';
		                items: viewModel treeVisualizationItems;
		                display: [ :assoc | assoc key ];
		                selectItem: viewModel defaultTreeVisualizationItem;
		                yourself.

	thresholdExpandInput := self newNumberInput
		                        beFloat;
		                        help:
			                        'Only nodes with a percentage of time greater than this threshold will be expanded';
		                        autoAccept: true;
		                        digits: 1;
		                        climbRate: 0.5;
		                        minimum: 0;
		                        maximum: 100;
		                        number: 0.0;
		                        yourself.
	thresholdFilterInput := self newNumberInput
		                        beFloat;
		                        help:
			                        'Only nodes with a percentage of time greater than this threshold will be shown';
		                        autoAccept: true;
		                        digits: 1;
		                        climbRate: 0.5;
		                        minimum: 0;
		                        maximum: 100;
		                        number: 100.0;
		                        yourself.

	applyCustomExpandButton := self newButton
		                           label: 'Apply';
		                           yourself.
	filterNodesButton := self newButton
		                     label: 'Filter';
		                     yourself.

	expandAllButton := self newButton
		                   label: 'Expand All';
		                   yourself.

	collapseAllButton := self newButton
		                     label: 'Collapse All';
		                     yourself.

	"Actions"
	collapseAllButton action: [ treeTable collapseAll ].

	expandAllButton action: [ treeTable expandAll ].

	applyCustomExpandButton action: [ self expandNodesOver: thresholdExpandInput number " onErrorDo: [ :e | 
		                       self
			                       warning: 'Invalid number'
			                       for: self thresholdExpandInput.
		                       ^ self ]" ].

	filterNodesButton action: [ 
		self hideNodesUnder: thresholdFilterInput number ].

	treeDropList whenSelectedItemChangedDo: [ :item | 
		| showLeavesOnly |
		showLeavesOnly := item value.
		viewModel showLeavesOnly: showLeavesOnly.
		expandAllButton enabled: showLeavesOnly not.
		collapseAllButton enabled: showLeavesOnly not.
		applyCustomExpandButton enabled: showLeavesOnly not.
		thresholdExpandInput enabled: showLeavesOnly not.
		self updateResults ].

	"Layout"
	^ SpBoxLayout newTopToBottom
		  add: (self newLabel
				   label: 'Configure results display';
				   yourself);
		  add: (SpBoxLayout newLeftToRight
				   add: treeDropList;
				   add: expandAllButton width: 100;
				   add: collapseAllButton width: 100;
				   add: (self newLabel label: 'Expand nodes over:')
				   width: 190;
				   add: thresholdExpandInput width: 55;
				   add: (self newLabel label: '%') width: 25;
				   add: applyCustomExpandButton width: 100;
				   yourself);
		  add: (self newLabel
				   label: 'Filter results';
				   yourself);
		  add: (SpBoxLayout newLeftToRight
				   add: (self newLabel
						    label: 'Hide nodes under:';
						    yourself)
				   expand: false fill: true;
				   add: thresholdFilterInput width: 55;
				   add: filterNodesButton expand: false fill: false;
				   yourself);
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
		  children: [ :node | node sons asOrderedCollection sort reverse ];
		  addColumn:
			  ((SpStringTableColumn title: 'Tally' evaluated: #tally)
				   width: 200;
				   yourself);
		  yourself
	"addColumn: (SpLinkTableColumn new
				   title: 'Go';
				   width: 70;
				   evaluated: [ :aNode | '->' ];
				   action: [ :aNode |  attributeTable toggleFilter: aNode variableTag. owner updateHeaderBar. ];
				   sortFunction: #variableTag ascending;
				   yourself);"
]

{ #category : #accessing }
ProfilerResultsPresenter >> searchInput [
	^ searchInput 
]

{ #category : #update }
ProfilerResultsPresenter >> showDoItNode [

	| selectorsPath |
	selectorsPath := #( 'runBlockAndProfile:' 'ensure:' 'DoIt' ).
	treeTable expandAllSuchThat: [ :item | 
		(selectorsPath indexOf: item tallyObject method selector) > 0 ].

	[ 
	treeTable
		selectPathOfNodes: selectorsPath
		evaluationBlock: [ :item :selector | 
		item data tallyObject method selector = selector ] ]
		on: SubscriptOutOfBounds
		do: [ "this occurs when the profiled function took too little time" 
			self inform: 'Impossible to display the profiled code because its execution time was too short' ]
]

{ #category : #subscription }
ProfilerResultsPresenter >> subscribeOnProfilingAnnouncements [

	viewModel announcer when: ProfilingFinishedAnnouncement do: [ 
		self updateResults.
		self showDoItNode ]
]

{ #category : #accessing }
ProfilerResultsPresenter >> summaryText [

	^ summaryText
]

{ #category : #accessing }
ProfilerResultsPresenter >> thresholdExpandInput [

	^ thresholdExpandInput
]

{ #category : #accessing }
ProfilerResultsPresenter >> treeDropList [

	^ treeDropList
]

{ #category : #accessing }
ProfilerResultsPresenter >> treeTable [

	^ treeTable
]

{ #category : #subscription }
ProfilerResultsPresenter >> unsubscribeFromProfilingAnnouncements [

	viewModel announcer unsubscribe: self
]

{ #category : #update }
ProfilerResultsPresenter >> updateResults [

	treeTable roots: viewModel rootItems.
	summaryText label:
		'Reporting - ', viewModel totalTally asString ,' tallies, ' , viewModel totalTime asString
		, ' msec.'
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
