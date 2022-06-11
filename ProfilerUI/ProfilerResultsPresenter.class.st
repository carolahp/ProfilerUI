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

{ #category : #private }
ProfilerResultsPresenter >> collapsePath: aPath [
	treeTable
		collapsePath: aPath;
		selectPath: aPath
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

{ #category : #'event handling' }
ProfilerResultsPresenter >> handleArrowLeft [

	self collapsePath: treeTable selection selectedPath
]

{ #category : #'event handling' }
ProfilerResultsPresenter >> handleArrowRight [

	self expandPath: treeTable selection selectedPath
]

{ #category : #private }
ProfilerResultsPresenter >> hideNodesUnder: aNumber [ 
	viewModel hideNodesUnder: aNumber.
	self updateResults
]

{ #category : #initialization }
ProfilerResultsPresenter >> initializeActions [

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

	browseButton action: [ 
		treeTable selectedItem tallyObject method browse ].

	thresholdExpandInput eventHandler
		whenFocusLostDo: [ 
			thresholdExpandInput number isZero ifTrue: [ 
					thresholdExpandInput number: 0.0 ] ];
		whenFocusReceivedDo: [ thresholdExpandInput selectAll ];
		whenMouseDownDo: [ :evt | thresholdExpandInput selectAll ].

	thresholdFilterInput eventHandler
		whenFocusReceivedDo: [ thresholdFilterInput selectAll ];
		whenMouseDownDo: [ :evt | thresholdFilterInput selectAll ]
]

{ #category : #initialization }
ProfilerResultsPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			 add: summaryText height: self class toolbarHeight;
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
		                yourself.
	self showLeavesOnly: viewModel showLeavesOnly.
	
	thresholdExpandInput := self newNumberInput
		                        beFloat;
		                        help:
			                        'Only nodes with a percentage of time greater than this threshold will be expanded';
		                        autoAccept: true;
		                        digits: 1;
		                        climbRate: 0.5;
		                        minimum: 0;
		                        maximum: 100;
		                        number: 0;
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
		                        number: viewModel showNodeThreshold;
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

	applyCustomExpandButton action: [ 
		self expandNodesOver: thresholdExpandInput number ].

	filterNodesButton action: [ 
		self hideNodesUnder: thresholdFilterInput number ].

	treeDropList whenSelectedItemChangedDo: [ :item | 
		viewModel showLeavesOnly: item value.
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
				   add: (self newLabel label: 'Expand nodes over:') width: 190;
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
				   add: (self newLabel
						    label: '%';
						    yourself)
				   width: 25;
				   add: filterNodesButton expand: false fill: false;
				   yourself);
		  yourself.
	
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
		bindKeyCombination: Character arrowLeft asKeyCombination 
			toAction: [ self handleArrowLeft ];
		bindKeyCombination: Character arrowRight asKeyCombination 
			toAction: [ self handleArrowRight ];
		  yourself
	"addColumn: (SpLinkTableColumn new
				   title: 'Go';
				   width: 70;
				   evaluated: [ :aNode | '->' ];
				   action: [ :aNode |  attributeTable toggleFilter: aNode variableTag. owner updateHeaderBar. ];
				   sortFunction: #variableTag ascending;
				   yourself);"
]

{ #category : #update }
ProfilerResultsPresenter >> selectDoItNode [

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

{ #category : #private }
ProfilerResultsPresenter >> showLeavesOnly: aBoolean [

	treeDropList selectItem:
		(treeDropList items select: [ :item | item value = aBoolean ]) first.
	viewModel showLeavesOnly: aBoolean
]

{ #category : #subscription }
ProfilerResultsPresenter >> subscribeOnProfilingAnnouncements [

	viewModel announcer when: ProfilingFinishedAnnouncement do: [ 
		self updateResults.
		self selectDoItNode.
		self updateSummaryText ]
]

{ #category : #accessing }
ProfilerResultsPresenter >> summaryText [

	^ summaryText
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
