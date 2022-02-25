Extension { #name : #FTRootItem }

{ #category : #'*ProfilerUI' }
FTRootItem >> expandAllSuchThat: aBlock [
	
	children do: [ :each | each expandAllSuchThat: aBlock ]
]
