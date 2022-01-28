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
		'controller',
		'summaryText'
	],
	#category : #'ProfilerUI-View'
}

{ #category : #'instance creation' }
ProfilerResultsPresenter class >> withController: aProfilerController [
	^ self basicNew
		controller: aProfilerController;
		initialize;
		yourself
]

{ #category : #accessing }
ProfilerResultsPresenter >> controller [

	^ controller
]

{ #category : #accessing }
ProfilerResultsPresenter >> controller: anObject [

	controller := anObject
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

	thresholdText := self newNumberInput
		                 help: 'Minimum tally value of tree nodes';
		                 numberType: Integer;
		                 minimum: 0;
		                 maximum: 1000;
		                 number: 0;
		                 yourself.
	minTimeText := self newNumberInput
		               help: 'Minimum node weight make it expansible';
		               digits: 1;
		               numberType: Float;
		               minimum: 0;
		               maximum: 100;
		               number: 3.0;
		               yourself.
	treeDropList := self newDropList
		                help: 'Result visualization mode';
		                items: { 'Full tree'. 'Leaves' };
		                yourself.

	^ SpBoxLayout newLeftToRight
		  add: (self newLabel label: 'Threshold') width: 100;
		  add: thresholdText width: 50;
		  add: (self newLabel label: 'Min time %') width: 100;
		  add: minTimeText width: 50;
		  add: treeDropList;
		  yourself
]

{ #category : #initialization }
ProfilerResultsPresenter >> newTreeTablePresenter [

	^ self newTreeTable
		  addColumn: ((SpStringTableColumn
				    title: 'Weight'
				    evaluated: [ :each | 
					    (each weight roundTo: 0.1) asString , ' %' ])
				   width: 50;
				   yourself);
		  addColumn: ((SpStringTableColumn
				    title: 'Time'
				    evaluated: [ :each | 
					    each time rounded asStringWithCommas , ' ms' ])
				   width: 50;
				   yourself);
		  addColumn:
		  (SpStringTableColumn title: 'name' evaluated: #asString);
		  children: [ :node | node sons ];
		  addColumn: (SpLinkTableColumn new
				   title: 'Go';
				   width: 70;
				   evaluated: [ :aNode | '->' ];
				   "action: [ :aNode |  attributeTable toggleFilter: aNode variableTag. owner updateHeaderBar. ];"
				   sortFunction: #variableTag ascending;
				   yourself);
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

{ #category : #subscription }
ProfilerResultsPresenter >> subscribeOnProfilingAnnouncements [
	controller announcer when: ProfilingFinishedAnnouncement do: [ self updateResults ].
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

	controller announcer unsubscribe: self
]

{ #category : #update }
ProfilerResultsPresenter >> updateResults [
	
	treeTable 
		roots: controller rootTallyItems; 
		expandRoots.
	summaryText label: 'Reporting - 186 tallies, ', controller totalTime asString ,' msec.' 
]
