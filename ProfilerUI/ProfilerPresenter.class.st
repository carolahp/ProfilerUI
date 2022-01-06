Class {
	#name : #ProfilerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'code',
		'profileIt',
		'allProcesses',
		'navigationBar',
		'treeTable'
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

	code := self newCode.
	allProcesses := self newCheckBox
		                label: 'All processes';
		                yourself.
	profileIt := self newButton
		             icon: (self iconNamed: #glamorousGo);
		             label: 'Profile it';
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
		                 addItem: (SpToolbarButtonPresenter new
				      					label: '> Process 1';            
										help: 'Take process 1 as the root of the execution tree';
				                  action: [ self inform: 'Process1' ];
				                  yourself);
		                 yourself.

	^ SpBoxLayout newTopToBottom
		  add: navigationBar;
		  "add: treeTable;"
		  yourself
	"treeTable := self newTreeTable
		addColumn: (SpIndexTableColumn new 
			title: 'Weight';
			sortFunction: #yourself ascending;
			beNotExpandable;
			yourself);
		addColumn: (SpIndexTableColumn new 
			title: 'Time';
			sortFunction: #yourself ascending;
			beNotExpandable;
			yourself);
		addColumn: (SpStringTableColumn new  
			title: 'Name'; 
			evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each ];
			sortFunction: #printString ascending;
			yourself);
		yourself."
]

{ #category : #accessing }
ProfilerPresenter >> title [
	
	^ 'Profiler'.
]
