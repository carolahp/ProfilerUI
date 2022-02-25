Extension { #name : #FTBasicItem }

{ #category : #'*ProfilerUI' }
FTBasicItem >> expandAllSuchThat: aBlock [
	(aBlock value: data) ifFalse: [ ^ self ].
	children ifNil: [ ^ self ].
	self expand.
	children do: [ :each | each expandAllSuchThat: aBlock ]
]
