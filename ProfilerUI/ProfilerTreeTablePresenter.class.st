"
A presenter for tree with a table used by the ProfilerUI to optimize rendering performance, but using more memory.
"
Class {
	#name : #ProfilerTreeTablePresenter,
	#superclass : #SpTreeTablePresenter,
	#instVars : [
		'viewModel'
	],
	#category : #'ProfilerUI-View'
}

{ #category : #specs }
ProfilerTreeTablePresenter class >> adapterName [ 

	^ #ProfilerTreeTableAdapter
]

{ #category : #'expanding-collapsing' }
ProfilerTreeTablePresenter >> expandAllSuchThat: aBlock [

	self withAdapterPerformOrDefer: [ :anAdapter | 
		anAdapter widget expandAllSuchThat: aBlock ]
]

{ #category : #'expanding-collapsing' }
ProfilerTreeTablePresenter >> expandNodesOver: aNumber [

	self expandAllSuchThat: [ :item | 
		item weight >= aNumber ].
	self refresh
]

{ #category : #'expanding-collapsing' }
ProfilerTreeTablePresenter >> hideNodesUnder: aNumber [ 
	viewModel hideNodesUnder: aNumber.
]

{ #category : #initialization }
ProfilerTreeTablePresenter >> initialize [
	super initialize.
	self addColumn: (SpCompositeTableColumn new
				   addColumn: (SpImageTableColumn evaluated: [ :item | self iconNamed: item icon ]);
				   addColumn: (SpStringTableColumn
						    title: 'Method or Block'
						    evaluated: [ :item | item reportString ]);
				   yourself).
		  "children: [ :item | 
			  | perCent |
			  perCent := viewModel showNodeThreshold.
			  (item sonsOver: perCent) asOrderedCollection sort reverse ];"
		  "bindKeyCombination: Character arrowLeft asKeyCombination
		  toAction: [ self handleArrowLeft ];
		  bindKeyCombination: Character arrowRight asKeyCombination
		  toAction: [ self handleArrowRight ];"
		  
		  "addColumn:
			  ((SpStringTableColumn title: 'Tally' evaluated: #tally)
				   width: 200;
				   yourself);""addColumn:
			  (SpLinkTableColumn new
					title: 'Go into';
					width: 70;
					evaluated: [ :node | '->' ];
					action: [ :node | treeTable selectItem: node. self goInto  ];
					yourself);""addColumn: (SpLinkTableColumn new
				   title: 'Go';
				   width: 70;
				   evaluated: [ :aNode | '->' ];
				   action: [ :aNode |  attributeTable toggleFilter: aNode variableTag. owner updateHeaderBar. ];
				   sortFunction: #variableTag ascending;
				   yourself)"
]

{ #category : #updating }
ProfilerTreeTablePresenter >> resetContents [
	self withAdapterPerformOrDefer: [ :anAdapter |
		anAdapter widget buildContents ]
]

{ #category : #selection }
ProfilerTreeTablePresenter >> selectNodePath: aCollection [ 

	self withAdapterPerformOrDefer: [ :anAdapter |
		anAdapter widget selectNodePath: aCollection ]
]

{ #category : #'api - selection' }
ProfilerTreeTablePresenter >> selectPath: aPath scrollToSelection: shouldScrollToSelection [
	self selectNodePath: aPath.
	self withAdapterPerformOrDefer: [ :anAdapter |
		
		shouldScrollToSelection ifTrue: [ 
			adapter scrollToSelection ] ]
]

{ #category : #'api - selection' }
ProfilerTreeTablePresenter >> selectedItem [

	self withAdapterPerformOrDefer: [ :anAdapter | 
		^ anAdapter selectedItem ]
]

{ #category : #'accessing - model' }
ProfilerTreeTablePresenter >> setModelBeforeInitialization: aDomainObject [

	viewModel := aDomainObject
]

{ #category : #'expanding-collapsing' }
ProfilerTreeTablePresenter >> updateResults [

	self roots: viewModel rootItems.
	self refresh
]

{ #category : #accessing }
ProfilerTreeTablePresenter >> viewModel [
	^ viewModel
]

{ #category : #adapter }
ProfilerTreeTablePresenter >> whenSelectedItemChangedSend: aSymbol to: anObject [

	self withAdapterPerformOrDefer: [ :anAdapter | 
		anAdapter widget model onSelectionChangeSend: aSymbol to: anObject ]
]
