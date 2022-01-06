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

	code := self newCode
		text: '10000 factorial'.
		
	allProcesses := self newCheckBox
		                label: 'All processes';
		                yourself.
	profileIt := self newButton
		             icon: (self iconNamed: #glamorousGo);
		             label: 'Profile it';
						 action: [ self runProfiler ] 
		             yourself.

	^ SpBoxLayout newTopToBottom
		  add: code;
		  add: (SpBoxLayout newLeftToRight
				   add: allProcesses;
				   add: profileIt;
				   yourself);
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
		roots: {Object};
		children: [ :node | node subclasses ].
		"contextMenu: [ (self rootCommandsGroup / 'Results tools') beRoot asMenuPresenter ]".

	^ SpBoxLayout newTopToBottom
		  add: navigationBar;
		  add: treeTable;
		  yourself

]

{ #category : #accessing }
ProfilerPresenter >> runProfiler [
	profiler := AndreasSystemProfiler spyOn: [ code text ]
]

{ #category : #accessing }
ProfilerPresenter >> title [
	
	^ 'Profiler'.
]
