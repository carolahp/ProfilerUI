Extension { #name : #SpTreeTablePresenter }

{ #category : #'*ProfilerUI' }
SpTreeTablePresenter >> expandAllSuchThat: aFullBlockClosure [ 
	| rootItem |
	rootItem := self adapter widget dataSource rootItem.
	rootItem collapseAll.
	rootItem expandAllSuchThat: aFullBlockClosure 
]
