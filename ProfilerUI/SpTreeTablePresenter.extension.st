Extension { #name : #SpTreeTablePresenter }

{ #category : #'*ProfilerUI' }
SpTreeTablePresenter >> expandAllSuchThat: aFullBlockClosure [ 
	| rootItem |
	rootItem := self adapter widget dataSource rootItem.
	rootItem collapseAll.
	rootItem expandAllSuchThat: aFullBlockClosure 
]

{ #category : #'*ProfilerUI' }
SpTreeTablePresenter >> selectPathOfNodes: aCollection evaluationBlock: aFullBlockClosure [

	| node selectorsPath indexPath |
	selectorsPath := aCollection.
	node := self adapter widget dataSource rootItem.

	indexPath := selectorsPath collect: [ :selector | 
		             | child index |
		             child := (node children select: [ :chld | 
										aFullBlockClosure value: chld value: selector ]) first.
		             index := node children indexOf: child.
		             node := child.
		             index ].
	self selectPath: indexPath scrollToSelection: true.
	self refresh
]
