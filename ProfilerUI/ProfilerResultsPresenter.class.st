"
I am a panel in the ProfilerPresenter containing the profiling process results together with parameters to filter these results
"
Class {
	#name : #ProfilerResultsPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'searchInput',
		'navigationBar',
		'minTimeText',
		'treeDropList',
		'treeTable',
		'thresholdText',
		'summaryText',
		'viewModel'
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
ProfilerResultsPresenter >> applyFilter [

	| minTimePercentage thresholdTime |
	minTimePercentage := [ self minTimeText number ] onErrorDo: [ :e | 
		                     self
			                     warning: 'Invalid number'
			                     for: self minTimeText.
		                     ^ self ].
	thresholdTime := [ self thresholdText number ] onErrorDo: [ :e | 
		                 self
			                 warning: 'Invalid number'
			                 for: self minTimeText.
		                 ^ self ].
	treeTable expandAllSuchThat: [ :item | 
		item time >= thresholdTime and: [ item weight >= minTimePercentage ] ].
	treeTable refresh
]

{ #category : #initialization }
ProfilerResultsPresenter >> initializeActions [
	searchInput whenTextChangedDo: [ self error: 'implement me' ]
]

{ #category : #initialization }
ProfilerResultsPresenter >> initializePresenters [

	searchInput := self newTextInput
		               placeholder: 'Filter results';
		               autoAccept: true.
	
	navigationBar := self newToolbar
		                 addItem: (SpToolbarButtonPresenter new
				                  label: 'Root';
				                  help: 'Root of the execution tree';
				                  action: [ self inform: 'Root!' ]).
				
	self layout: (SpBoxLayout newTopToBottom
			 add: (summaryText := self newLabel label: 'Reporting ') height: self class toolbarHeight;
			 add: searchInput height: self class toolbarHeight;
			 add: navigationBar height: self class toolbarHeight;
			 add: (treeTable := self newTreeTablePresenter);
			 add: self newResultsConfigurationPresenter
			 height: self class toolbarHeight).
				
	self subscribeOnProfilingAnnouncements.
	self initializeActions
]

{ #category : #accessing }
ProfilerResultsPresenter >> minTimeText [

	^ minTimeText
]

{ #category : #accessing }
ProfilerResultsPresenter >> navigationBar [

	^ navigationBar
]

{ #category : #initialization }
ProfilerResultsPresenter >> newResultsConfigurationPresenter [

	| filterButton |
	thresholdText := self newNumberInput
		                 help: 'Minimum tally time to display a node';
		                 numberType: Integer;
		                 minimum: 0;
		                 maximum: 1000;
		                 number: 0;
		                 yourself.
	minTimeText := self newNumberInput
		               help:
			               'Minimum node weight (tally time / total time) to display';
		               digits: 1;
		               numberType: Float;
		               minimum: 0;
		               maximum: 100;
		               number: 3.0;
		               yourself.
	treeDropList := self newDropList
		                help: 'Result visualization mode';
		                items: viewModel treeVisualizationItems;
		                display: [ :assoc | assoc key ];
		                selectItem: viewModel defaultTreeVisualizationItem;
		                yourself.
	treeDropList whenSelectedItemChangedDo: [ :item | 
		viewModel showLeavesOnly: item value.
		self updateResults ].
	filterButton := self newButton
		                label: 'Filter';
		                yourself.
	filterButton action: [ self applyFilter ].

	^ SpBoxLayout newLeftToRight
		  add: (self newLabel label: 'Time threshold [ms]') width: 100;
		  add: thresholdText width: 50;
		  add: (self newLabel label: 'Min weight [%]') width: 100;
		  add: minTimeText width: 50;
		  add: treeDropList;
		  add: filterButton;
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
			children: [ :node | node sons ];
		  addColumn:
			  ((SpStringTableColumn title: 'Tally' evaluated: #tally)
				   width: 200;
				   yourself);
		  addColumn: (SpLinkTableColumn new
				   title: 'Go';
				   width: 70;
				   evaluated: [ :aNode | '->' ];
				   "action: [ :aNode |  attributeTable toggleFilter: aNode variableTag. owner updateHeaderBar. ];"
				   sortFunction: #variableTag ascending;
				   yourself);
		  yourself
]

{ #category : #accessing }
ProfilerResultsPresenter >> searchInput [
	^ searchInput 
]

{ #category : #update }
ProfilerResultsPresenter >> showDoItNode [
	treeTable expandAllSuchThat: [ :item | 
		(#( runBlockAndProfile: newProcess ensure: DoIt ) indexOf:
			 item tallyObject method selector) > 0 ].
	
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

	treeTable roots: viewModel rootItems. ";
		expandRoots"
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
