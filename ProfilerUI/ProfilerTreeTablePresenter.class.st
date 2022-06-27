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

{ #category : #api }
ProfilerTreeTablePresenter >> collapsePath: aPath [
	self
		collapsePath: aPath;
		selectPath: aPath
]

{ #category : #'expanding-collapsing' }
ProfilerTreeTablePresenter >> expandAllSuchThat: aBlock [

	self withAdapterPerformOrDefer: [ :anAdapter | 
		| rootItem |
		rootItem := anAdapter widget dataSource rootItem.
		rootItem collapseAll.
		rootItem expandAllSuchThat: aBlock ]
]

{ #category : #'expanding-collapsing' }
ProfilerTreeTablePresenter >> expandNodesOver: aNumber [

	self expandAllSuchThat: [ :item | 
		item weight >= aNumber ].
	self refresh
]

{ #category : #api }
ProfilerTreeTablePresenter >> expandPath: aPath [
	self
		expandPath: aPath;
		selectPath: aPath
]

{ #category : #actions }
ProfilerTreeTablePresenter >> goInto: aTallyModel [
	viewModel setTallyRoot: aTallyModel
]

{ #category : #actions }
ProfilerTreeTablePresenter >> goIntoSelectedItem [

	self goInto: self selectedItem
]

{ #category : #'event handling' }
ProfilerTreeTablePresenter >> handleArrowLeft [

	self collapsePath: self selection selectedPath
]

{ #category : #'event handling' }
ProfilerTreeTablePresenter >> handleArrowRight [

	self expandPath: self selection selectedPath
]

{ #category : #'expanding-collapsing' }
ProfilerTreeTablePresenter >> hideNodesUnder: aNumber [

	viewModel hideNodesUnder: aNumber
]

{ #category : #initialization }
ProfilerTreeTablePresenter >> initialize [
	super initialize.
	self addColumn: (SpCompositeTableColumn new
				   addColumn: (SpImageTableColumn evaluated: [ :item | self iconNamed: item icon ]);
				   addColumn: (SpStringTableColumn
						    title: 'Method or Block'
						    evaluated: [ :item | item reportString ]);
				   yourself);
		  children: [ :item | 
			  | perCent |
			  perCent := viewModel showNodeThreshold.
			  (item sonsOver: perCent) asOrderedCollection sort reverse ];
		  bindKeyCombination: Character arrowLeft asKeyCombination
		  toAction: [ self handleArrowLeft ];
		  bindKeyCombination: Character arrowRight asKeyCombination
		  toAction: [ self handleArrowRight ];
		  contextMenu: self menu
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

{ #category : #accessing }
ProfilerTreeTablePresenter >> menu [
	^ self newMenu
		  title: 'Menu';
		  addGroup: [ :aGroup | 
			  aGroup
				  addItem: [ :anItem | 
					  anItem
						  name: 'Go Into';
						  shortcut: $g meta;
						  description: 'Make the root of the tree';
						  action: [ self goIntoSelectedItem ] ];
				  addItem: [ :anItem | 
					  anItem
						  name: 'Browse';
						  shortcut: $b meta;
						  description: 'Browse in Calypso';
						  action: [ self selectedTallyObject originMethod browse ] ];
				  addItem: [ :anItem | 
					  anItem
						  name: 'Inspect';
						  shortcut: $i meta;
						  description: 'Open inspector';
						  action: [ self selectedTallyObject inspect ] ] ]
]

{ #category : #'expanding-collapsing' }
ProfilerTreeTablePresenter >> selectPathOfNodes: selectorsPath evaluationBlock: aBlock [

	self withAdapterPerformOrDefer: [ :anAdapter | 
		| item indexPath |
		selectorsPath.
		item := anAdapter widget dataSource rootItem.

		indexPath := selectorsPath collect: [ :selector | 
			             | child index |
			             child := (item children select: [ :chld | 
				                       aBlock
					                       value: chld
					                       value: selector ]) first.
			             index := item children indexOf: child.
			             item := child.
			             index ].
		self selectPath: indexPath scrollToSelection: true.
		self refresh ]
]

{ #category : #accessing }
ProfilerTreeTablePresenter >> selectedTallyObject [
	^ self selectedItem tallyObject
]

{ #category : #'expanding-collapsing' }
ProfilerTreeTablePresenter >> updateResults [
	
	self roots: viewModel rootItems.
	self expandRoots
]

{ #category : #accessing }
ProfilerTreeTablePresenter >> viewModel: aProfilerViewModel [ 
	viewModel := aProfilerViewModel
]
