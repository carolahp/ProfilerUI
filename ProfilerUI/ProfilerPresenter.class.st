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
		'profilerUI'
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
		initialExtent: 500 @ 500
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

	navigationBar := self newToolbar
		                 addItem: (SpToolbarButtonPresenter new
				                  label: 'Root';
				                  help: 'Root of the execution tree';
				                  action: [ self inform: 'Root!' ];
				                  yourself);
		                 yourself.

	treeTable := self newTreeTable.
	treeTable
		addColumn: ((SpStringTableColumn 
			title: 'Weight'
			evaluated: [:each | each weight asString, ' %'])
			width: 50;
			yourself);
			
		addColumn: ((SpStringTableColumn 
			title: 'Time'
			evaluated: [:each | each time asString, ' ms'])
			width: 50;
			yourself);
		
		addColumn: (SpStringTableColumn 
			title: 'name'
			evaluated: #asString);
		children: [ :node | node sonsOver: 0 ].
		"contextMenu: [ (self rootCommandsGroup / 'Results tools') beRoot asMenuPresenter ]".

	^ SpBoxLayout newTopToBottom
		  add: navigationBar height: self class toolbarHeight;
		  add: treeTable;
		  yourself

]

{ #category : #actions }
ProfilerPresenter >> runProfiler [

	profilerUI := self newProfiler.
	profilerUI startProfiling.
	
	[ OpalCompiler new evaluate: code text ] ensure: [ 
		self updateResultPanel.
		profilerUI stopProfiling ]
]

{ #category : #update }
ProfilerPresenter >> updateResultPanel [
	
	treeTable 
		roots: profilerUI rootTallyItems; 
		expandRoots
]
