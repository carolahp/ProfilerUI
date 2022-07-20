Extension { #name : #FTRootItem }

{ #category : #'*ProfilerUI' }
FTRootItem >> expandAllSuchThat: aBlock [
	
	self deprecated: 'use ProfilerTreeMorph'.
	children do: [ :each | each expandAllSuchThat: aBlock ]
]
