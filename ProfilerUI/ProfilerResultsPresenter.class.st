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

{ #category : #private }
ProfilerResultsPresenter >> addToolbarItem: anItem [

	| navItem |
	navItem := ProfilerToolbarButtonPresenter new.
	navItem
		object: anItem;
		label: anItem methodName;
		help: 'Display ' , anItem methodName , ' as root';
		action: [ 
			|selectorsPath theNode|
			navItem node ifNotNil: [ 
				selectorsPath := navItem node path collect: [:item | item item method selector] ].
			
			viewModel setTallyRoot: anItem.
			selectorsPath ifNotNil: [ treeTable expandAllSuchThat: [ :item | | bool |
					bool := (selectorsPath indexOf: item item method selector) > 0.
					bool ifTrue: [ theNode := item ].
					bool ].
				treeTable selectPath: theNode path scrollToSelection: true ] .
			 ].
		
	navigationBar items ifNotEmpty: [ :items |
		items last node: treeTable selectedItem ].
	
	
	navigationBar addItem: navItem.
	^ navItem
]

{ #category : #private }
ProfilerResultsPresenter >> goInto: anItem [

	| toolbarButton |
	self removeToolbarItemsAfter: navigationBar selectedItem.
	"Either the button in the navigationBar must be created (when going into an item in the treeTable)
	or it already exists (when it was clicked)"
	toolbarButton := (navigationBar items select: [ :item | 
		            item object == anItem ])
		           ifEmpty: [ self addToolbarItem: anItem ]
		           ifNotEmpty: [ :result | result first ].

	self selectToolbarItem: toolbarButton.
	self updateResults
]

{ #category : #'event handling' }
ProfilerResultsPresenter >> handleProfilingFinished [

	| navItem |
	self updateResults.
	treeTable expandRoots.
	viewModel showLeavesOnly ifFalse: [ self selectDoItNode ].
	self updateSummaryText.
	navigationBar removeAllItems.
	navItem := self addToolbarItem: viewModel tallyRoot.
	self selectToolbarItem: navItem.
	treeTable takeKeyboardFocus.
	self enabled: true
]

{ #category : #'event handling' }
ProfilerResultsPresenter >> handleProfilingStarted [
	
	viewModel reset.
	treeTable resetContents.
	self enabled: false
]

{ #category : #'event handling' }
ProfilerResultsPresenter >> handleSelectionChange [
	
	self handleSelectionChange: treeTable selectedItem
]

{ #category : #'event handling' }
ProfilerResultsPresenter >> handleSelectionChange: item [

	item
		ifNil: [ 
			browseButton disable.
			codePresenter methodOrBlock: nil ]
		ifNotNil: [ 
			browseButton enable.
			codePresenter methodOrBlock: item item methodOrBlock.
			navigationBar selectedItem ifNotNil: [ :btn | 
				btn object item = treeTable selectedItem item ifFalse: [ 
					btn node: treeTable selectedItem ] ] ]
]

{ #category : #initialization }
ProfilerResultsPresenter >> initializeActions [

	treeTable whenSelectedItemChangedSend: #handleSelectionChange to: self.
	"Code section actions"
	browseButton action: [ treeTable selectedItem browseItem ].
	
	"Configuration section actions"
	collapseAllButton action: [ treeTable collapseAll. treeTable takeKeyboardFocus ].

	expandAllButton action: [ treeTable expandAll. treeTable takeKeyboardFocus ].

	thresholdExpandInput whenTextChangedDo: [ :text |
		text asInteger ifNotNil: [ :limit | 
			treeTable collapseAll.
			treeTable expandNodesOver: limit ] ].

	thresholdFilterInput whenTextChangedDo: [ :text | 
		text asInteger ifNotNil: [ :limit |
			treeTable hideNodesUnder: limit.
			self updateResults ] ].	
	
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
			 add: (treeTable := self newProfilerTreeTable);
			 add: self newConfigurationSectionLayout height: h * 3;
			 add: (codePresenter := self newProfilerCode);
			 add: (SpBoxLayout newLeftToRight addLast:
						  (browseButton := self newBrowseButton))
			 height: h;
			 yourself).
	self initializeActions
]

{ #category : #'private - factory' }
ProfilerResultsPresenter >> newBrowseButton [

	^ self newButton
		  icon: (self iconNamed: #glamorousBrowse);
		  label: 'Browse';
		  disable;
		  yourself
]

{ #category : #'private - factory' }
ProfilerResultsPresenter >> newConfigurationSectionLayout [

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

{ #category : #'private - factory' }
ProfilerResultsPresenter >> newProfilerCode [

	^ self instantiate: ProfilerCodePresenter 
]

{ #category : #'private - factory' }
ProfilerResultsPresenter >> newProfilerNumberInput [
	^ self instantiate: ProfilerNumberInput 
]

{ #category : #'private - factory' }
ProfilerResultsPresenter >> newProfilerToolbar [

	^ self instantiate: ProfilerToolbarPresenter 
]

{ #category : #'private - factory' }
ProfilerResultsPresenter >> newProfilerTreeTable [

	^ ProfilerTreeTablePresenter on: viewModel
]

{ #category : #'private - factory' }
ProfilerResultsPresenter >> newThresholdExpandInput [

	^ self newProfilerNumberInput
		  help: 'Only nodes with a percentage of time greater than this threshold will be expanded';
		  number: 0;
		  yourself
]

{ #category : #'private - factory' }
ProfilerResultsPresenter >> newThresholdFilterInput [

	^ self newProfilerNumberInput
		  help: 'Only nodes with a percentage of time greater than this threshold will be shown';
		  number: viewModel showNodeThreshold;
		  yourself
]

{ #category : #'private - factory' }
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

	| selectorsPath doItNode |
	
	selectorsPath := viewModel doItSelectorsPath.
	
	
	treeTable expandAllSuchThat: [ :item | | bool | 
		bool := (selectorsPath indexOf: item item method selector) > 0.
		bool ifTrue: [ doItNode := item ].
		bool ].
	doItNode ifNil: [ self inform: 'Excecution was too fast!'. ^ self ].
	treeTable selectNodePath: doItNode path.
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

{ #category : #'accessing - model' }
ProfilerResultsPresenter >> setModelBeforeInitialization: aDomainObject [

	viewModel := aDomainObject
]

{ #category : #subscription }
ProfilerResultsPresenter >> subscribeOnProfilingAnnouncements [

	viewModel announcer
		when: ProfilingStartedAnnouncement 
		do: [ self handleProfilingStarted ];
		when: ProfilingFinishedAnnouncement
		do: [ self handleProfilingFinished ];
		when: ProfilerResultsTreeRootChangedAnnouncement 
		do: [ :evt | self goInto: evt item ]
]

{ #category : #subscription }
ProfilerResultsPresenter >> unsubscribeFromProfilingAnnouncements [

	viewModel announcer unsubscribe: self
]

{ #category : #update }
ProfilerResultsPresenter >> updateResults [
	
	treeTable updateResults
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
