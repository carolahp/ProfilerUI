"
I am an abstract adapter for tallies (from different system profilers) to be used by the ProfilerPresenter
"
Class {
	#name : #TallyUI,
	#superclass : #Object,
	#instVars : [
		'tallyObject'
	],
	#category : #ProfilerUI
}

{ #category : #accessing }
TallyUI >> printOn: aStream [
	^ tallyObject printOn: aStream
]

{ #category : #querying }
TallyUI >> sonsOver: anInteger [ 
	^ (tallyObject sonsOver: anInteger) collect: #asTallyUI
]

{ #category : #accessing }
TallyUI >> tallyObject [

	^ tallyObject
]

{ #category : #accessing }
TallyUI >> tallyObject: anObject [

	tallyObject := anObject
]

{ #category : #accessing }
TallyUI >> time [
	^ 90
]

{ #category : #accessing }
TallyUI >> weight [
	^ 100
]
