Extension { #name : #FTBasicItem }

{ #category : #'*ProfilerUI' }
FTBasicItem >> expandAllSuchThat: aBlock [
	self deprecated: 'use ProfilerTreeMorph'.
	(aBlock value: data) ifFalse: [ ^ self ].
	children ifNil: [ ^ self ].
	self expand.
	children do: [ :each | each expandAllSuchThat: aBlock ]
]
