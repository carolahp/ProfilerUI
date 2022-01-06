Class {
	#name : #ProfilerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'code',
		'profileIt',
		'allProcesses',
		'navigationBar',
		'treeTable',
		'profiler'
	],
	#category : #ProfilerUI
}

{ #category : #examples }
ProfilerPresenter class >> open [
	<example>
	
	^ self new
		openWithSpec
]

{ #category : #accessing }
ProfilerPresenter >> initializePresenters [

	self layout: (SpBoxLayout newTopToBottom
			 add: self newInputPanel expand: true;
			 add: self newResultPanel expand: true;
			 yourself).

	self focusOrder
		add: code;
		add: profileIt
]

{ #category : #initialize }
ProfilerPresenter >> newInputPanel [

	code := self newCode text: '10000 factorial'.

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
				   add: allProcesses;
				   add: profileIt;
				   yourself)
		  withConstraints: [ :constraints | constraints height: self class toolbarHeight ];
		  yourself
]

{ #category : #initialize }
ProfilerPresenter >> newResultPanel [

	navigationBar := self newToolbar
		                 addItem: (SpToolbarButtonPresenter new
				                  label: 'Root';
				                  help: 'Show all processes in execution tree';
				                  action: [ self inform: 'Root!' ];
				                  yourself);
		                 yourself.

	treeTable := self newTreeTable.
	treeTable
		addColumn: (SpStringTableColumn 
			title: 'Number of subclasses'
			evaluated: #asString);
		children: [ :node | node sonsOver: 0 ].
		"contextMenu: [ (self rootCommandsGroup / 'Results tools') beRoot asMenuPresenter ]".

	^ SpBoxLayout newTopToBottom
		  add: navigationBar withConstraints: [ :constraints | constraints height: self class toolbarHeight ];
		  add: treeTable;
		  yourself

]

{ #category : #accessing }
ProfilerPresenter >> runProfiler [

	profiler := AndreasSystemProfiler new.
	profiler startProfiling.
	
	[ OpalCompiler new evaluate: code text ] ensure: [ 
		self updateResultPanel.
		profiler stopProfiling ]
]

{ #category : #accessing }
ProfilerPresenter >> title [
	
	^ 'Profiler'.
]

{ #category : #accessing }
ProfilerPresenter >> updateResultPanel [
	treeTable roots: profiler rootTallyItems
]
