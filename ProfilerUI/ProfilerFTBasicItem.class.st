"
Same as FTBasicItem but I store a reference to my parent and other calculated variables to prevent recursive calls
"
Class {
	#name : #ProfilerFTBasicItem,
	#superclass : #FTBasicItem,
	#instVars : [
		'parent',
		'numberOfVisibleChildren',
		'updateSelection'
	],
	#category : #'ProfilerUI-Morphic'
}

{ #category : #accessing }
ProfilerFTBasicItem >> calculateChildren [

	| result |
	result := super calculateChildren collect: [ :elem | 
		          elem
			          parent: self;
			          yourself ].
	numberOfVisibleChildren := nil.
	^ result
]

{ #category : #accessing }
ProfilerFTBasicItem >> childCollapsed: numberOfCollapsedItems [
	self isExpanded ifFalse: [ ^ self ].
	numberOfVisibleChildren := numberOfVisibleChildren - numberOfCollapsedItems.
	parent isRoot ifFalse: [ parent childCollapsed: numberOfCollapsedItems ]
]

{ #category : #accessing }
ProfilerFTBasicItem >> childExpanded: numberOfExpandedItems [
	self isExpanded ifFalse: [ ^ self ].
	numberOfVisibleChildren := numberOfVisibleChildren + numberOfExpandedItems.
	parent isRoot ifFalse: [ parent childExpanded: numberOfExpandedItems ]
]

{ #category : #'expanding-collapsing' }
ProfilerFTBasicItem >> collapse [
	| numberOfCollapsedItems |
	self isExpanded ifFalse: [ ^ self ].
	numberOfCollapsedItems := self numberOfVisibleChildren.
	parent isRoot ifFalse: [ parent childCollapsed: numberOfCollapsedItems ].
	isExpanded := false.
	numberOfVisibleChildren := 0.
	
	self updateSelection ifFalse: [ ^ self ].
	
	recentlyChanged := true.
	self dataSource
		updateSelectionWithCollectBlock:
			[ :indexOfCurrentSelection :indexOfCollapsedElement | 
			| changedBy |
			changedBy := numberOfCollapsedItems.
			(indexOfCurrentSelection between: indexOfCollapsedElement and: indexOfCollapsedElement + changedBy)
				ifTrue: [ indexOfCollapsedElement ]
				ifFalse: [ indexOfCurrentSelection < indexOfCollapsedElement
						ifTrue: [ indexOfCurrentSelection ]
						ifFalse: [ indexOfCurrentSelection - changedBy ] ] ]
]

{ #category : #'expanding-collapsing' }
ProfilerFTBasicItem >> collapseAll [
	updateSelection := false.
	super collapseAll.
	updateSelection := true
	
]

{ #category : #'expanding-collapsing' }
ProfilerFTBasicItem >> expand [

	self isExpanded ifTrue: [ ^ self ].
	isExpanded := true.
	numberOfVisibleChildren := super numberOfVisibleChildren.
	parent isRoot ifFalse: [ parent childExpanded: self numberOfVisibleChildren ].
	
	self updateSelection ifFalse: [ ^ self ].
	recentlyChanged := true.	
	self dataSource updateSelectionWithCollectBlock: [ 
		:indexOfCurrentSelection 
		:indexOfCollapsedElement | 
		indexOfCurrentSelection <= indexOfCollapsedElement
			ifTrue: [ indexOfCurrentSelection ]
			ifFalse: [ indexOfCurrentSelection + self numberOfVisibleChildren ] ]
]

{ #category : #'expanding-collapsing' }
ProfilerFTBasicItem >> expandAll [
	updateSelection := false.
	super expandAll.
	updateSelection := true
]

{ #category : #accessing }
ProfilerFTBasicItem >> numberOfVisibleChildren [

	^ numberOfVisibleChildren ifNil: [ numberOfVisibleChildren := super numberOfVisibleChildren ]
]

{ #category : #accessing }
ProfilerFTBasicItem >> parent: aProfilerFTItem [

	parent := aProfilerFTItem
]

{ #category : #accessing }
ProfilerFTBasicItem >> updateSelection [
	^ updateSelection ifNil: [ updateSelection := true ]
]
