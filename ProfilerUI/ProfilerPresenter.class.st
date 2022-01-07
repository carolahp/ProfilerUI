"
I am a graphical user interface for profiling code using different kinds of profilers
"
Class {
	#name : #ProfilerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'code',
		'profileIt',
		'allProcesses',
		'navigationBar',
		'treeTable',
		'profilerDropList',
		'profilerUI',
		'minTimeText',
		'thresholdText'
	],
	#category : #ProfilerUI
}

{ #category : #examples }
ProfilerPresenter class >> open [
	<example>
	
	^ self new
		openWithSpec
]

{ #category : #profiler }
ProfilerPresenter >> allProfilerClasses [
	^ { AndreasSystemProfiler . TimeProfiler . PreciseProfiler }
]

{ #category : #accessing }
ProfilerPresenter >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
			 add: self newInputPanel height: 100;
			 add: self newResultPanel expand: true;
			 yourself).

	self focusOrder
		add: code;
		add: profileIt
]

{ #category : #accessing }
ProfilerPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Profiler';
		initialExtent: 800 @ 500
]

{ #category : #'initialize presenter' }
ProfilerPresenter >> newInputPanel [

	code := self newCode text: '10000 factorial'.
	
	profilerDropList := self newDropList
		help: 'Select the desired profiler.';
		items: self allProfilerClasses;
		display: [ :each | each name ];
		yourself.
	
	allProcesses := self newCheckBox
		                label: 'All processes';
		                yourself.
	profileIt := self newButton
		             icon: (self iconNamed: #glamorousGo);
		             label: 'Profile it';
		             action: [ self runProfiler ] yourself.

	^ SpBoxLayout newTopToBottom
		  add: code;
		  add: (SpBoxLayout newLeftToRight
					add: profilerDropList;
				   add: allProcesses width: 100;
				   add: profileIt width: 100;
				   yourself)
		  height: self class toolbarHeight;
		  yourself
]

{ #category : #profiler }
ProfilerPresenter >> newProfiler [

	^ ProfilerUI new
		profiler: profilerDropList selectedItem new;
		yourself
]

{ #category : #'initialize presenter' }
ProfilerPresenter >> newResultPanel [

	| minTimeLabel thresholdLabel |
	navigationBar := self newToolbar
		                 addItem: (SpToolbarButtonPresenter new
				                  label: 'Root';
				                  help: 'Root of the execution tree';
				                  action: [ self inform: 'Root!' ];
				                  yourself);
		                 yourself.
	minTimeLabel := self newLabel label: 'Min time %'; yourself.
	minTimeText := self newNumberInput digits: 1; numberType: Float; minimum: 0; maximum: 100; number: 3.0; yourself.
	thresholdLabel := self newLabel label: 'Threshold'; yourself.
	thresholdText := self newNumberInput digits: 0; numberType: Integer; minimum: 0; number: 0; yourself.
	
	treeTable := self newTreeTable.
	treeTable
		addColumn: ((SpStringTableColumn 
			title: 'Weight'
			evaluated: [:each | (each weight roundTo: 0.1) asString, ' %'])
			width: 50;
			yourself);
			
		addColumn: ((SpStringTableColumn 
			title: 'Time'
			evaluated: [:each | each time rounded asStringWithCommas, ' ms'])
			width: 50;
			yourself);
		
		addColumn: (SpStringTableColumn 
			title: 'name'
			evaluated: #asString);
			children: [ :node | node sons ]
		"contextMenu: [ (self rootCommandsGroup / 'Results tools') beRoot asMenuPresenter ]";
		addColumn: ((SpStringTableColumn 
			title: 'Tally'
			evaluated: #tally)
			width: 100;
			yourself).
		
	^ SpBoxLayout newTopToBottom
		  add: navigationBar height: self class toolbarHeight;
		  add: treeTable;
		  add: (SpBoxLayout newLeftToRight
					add: thresholdLabel width: 100;
					add: thresholdText width: 50;
				   add: minTimeLabel width: 100;
				   add: minTimeText width: 50;
				   yourself)
		  height: self class toolbarHeight * 1.5;
		  yourself

]

{ #category : #actions }
ProfilerPresenter >> runProfiler [

	profilerUI := self newProfiler.
	profilerUI threshold: thresholdText number asInteger.
	profilerUI minTime: minTimeText number asFloat.
	
	profilerUI startProfiling.
	
	[ OpalCompiler new evaluate: code text ] ensure: [ 
		profilerUI stopProfiling.
		self updateResultPanel.
		profilerUI doReport.
		"self halt" ]
]

{ #category : #update }
ProfilerPresenter >> updateResultPanel [
	
	treeTable 
		roots: profilerUI rootTallyItems; 
		expandRoots
]
