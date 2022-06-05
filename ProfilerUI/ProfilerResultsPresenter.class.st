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
		'thresholdText',
		'summaryText',
		'viewModel',
		'codePresenter'
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

{ #category : #filtering }
ProfilerResultsPresenter >> applyCustomNodeExpansion [

	| thresholdPercentage |
	thresholdPercentage := [ self thresholdText number ] onErrorDo: [ :e | 
		                       self
			                       warning: 'Invalid number'
			                       for: self thresholdText.
		                       ^ self ].

	treeTable expandAllSuchThat: [ :item | 
		item weight >= thresholdPercentage ].

	treeTable refresh
]

{ #category : #initialization }
ProfilerResultsPresenter >> initializeActions [

	searchInput whenTextChangedDo: [ self error: 'implement me' ].

	treeTable whenSelectedItemChangedDo: [ :item | 
		codePresenter text:
			(item ifNil:[ '' ] ifNotNil:[ item tallyObject method sourceCode ]).
		codePresenter beForMethod: 
			(item ifNil:[ nil ] ifNotNil:[ item tallyObject method ]) ]
]

{ #category : #initialization }
ProfilerResultsPresenter >> initializePresenters [
	summaryText := self newLabel label: 'Reporting '.
	
	searchInput := self newTextInput
		               placeholder: 'Search selector in results';
		               autoAccept: true.
	
	navigationBar := self newToolbar
		                 addItem: (SpToolbarButtonPresenter new
				                  label: 'Root';
				                  help: 'Root of the execution tree';
				                  action: [ self inform: 'Root!' ]).
	treeTable := self newTreeTablePresenter.
	
	codePresenter := self newCode 
							beNotEditable.
							
	self layout: (SpBoxLayout newTopToBottom
			 add: summaryText height: self class toolbarHeight;
			 add: searchInput height: self class toolbarHeight;
			 add: navigationBar height: self class toolbarHeight;
			 add: treeTable;
			 add: self newResultsConfigurationPresenter height: self class toolbarHeight * 2;
			 add: codePresenter;
			 yourself).
				
	self subscribeOnProfilingAnnouncements.
	self initializeActions
]

{ #category : #accessing }
ProfilerResultsPresenter >> navigationBar [

	^ navigationBar
]

{ #category : #initialization }
ProfilerResultsPresenter >> newResultsConfigurationPresenter [

	| applyCustomExpandButton collapseAllButton expandAllButton |
	thresholdText := self newNumberInput
		                 help:
			                 'Only nodes with a percentage of time greater than this threshold will be expanded';
		                 numberType: Integer;
		                 minimum: 0.1;
		                 maximum: 100;
		                 number: 0;
		                 yourself.


	treeDropList := self newDropList
		                help: 'Results visualization mode';
		                items: viewModel treeVisualizationItems;
		                display: [ :assoc | assoc key ];
		                selectItem: viewModel defaultTreeVisualizationItem;
		                yourself.

	treeDropList whenSelectedItemChangedDo: [ :item | 
		viewModel showLeavesOnly: item value.
		self updateResults ].

	applyCustomExpandButton := self newButton
		                label: 'Apply';
		                yourself.
		
	applyCustomExpandButton action: [ self applyCustomNodeExpansion ].

	expandAllButton := self newButton
		                label: 'Expand All';
		                yourself.
	expandAllButton action: [ treeTable expandAll ].
	
	collapseAllButton := self newButton
		                label: 'Collapse All';
		                yourself.
	collapseAllButton action: [ treeTable collapseAll ].
	 

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight add: treeDropList; yourself)
		  height: self class toolbarHeight;
		  add: (SpBoxLayout newLeftToRight 
				add: expandAllButton width: 100;
				add: collapseAllButton width: 100;
				add: (self newLabel label: 'Expand only nodes heavier than:') width: 190;
				   add: thresholdText width: 50;
				   add: (self newLabel label: '%') width: 25;
					add: applyCustomExpandButton width: 100;
				   yourself)
		  height: self class toolbarHeight;
			  yourself
]

{ #category : #initialization }
ProfilerResultsPresenter >> newTreeTablePresenter [

	^ self newTreeTable
			"addColumn: (SpLinkTableColumn new
				   title: 'Go';
				   width: 70;
				   evaluated: [ :aNode | '->' ];
				   action: [ :aNode |  attributeTable toggleFilter: aNode variableTag. owner updateHeaderBar. ];
				   sortFunction: #variableTag ascending;
				   yourself);"
		  addColumn: ((SpStringTableColumn
				    title: 'Method'
				    evaluated: [ :node | node reportString ])
				   width: 500;
				   yourself);
			children: [ :node | node sons asOrderedCollection 
										sort: [ :a :b | a tallyObject tally > b tallyObject tally ] ];
		  addColumn:
			  ((SpStringTableColumn title: 'Tally' evaluated: #tally)
				   width: 200;
				   yourself);
		  yourself
]

{ #category : #accessing }
ProfilerResultsPresenter >> searchInput [
	^ searchInput 
]

{ #category : #update }
ProfilerResultsPresenter >> showDoItNode [

	| selectorsPath |
	selectorsPath := #( 'newProcess' 'runBlockAndProfile:'
	                    'ensure:' 'DoIt' ).
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
ProfilerResultsPresenter >> thresholdText [

	^ thresholdText
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
