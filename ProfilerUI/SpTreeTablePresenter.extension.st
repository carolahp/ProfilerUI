Extension { #name : #SpTreeTablePresenter }

{ #category : #'*ProfilerUI' }
SpTreeTablePresenter >> expandAllSuchThat: aBlock [

	self withAdapterPerformOrDefer: [ :anAdapter | 
		| rootItem |
		rootItem := anAdapter widget dataSource rootItem.
		rootItem collapseAll.
		rootItem expandAllSuchThat: aBlock ]
]

{ #category : #'*ProfilerUI' }
SpTreeTablePresenter >> selectPathOfNodes: selectorsPath evaluationBlock: aBlock [

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
