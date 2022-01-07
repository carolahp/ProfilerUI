"
I am an abstract adapter for tallies (from different system profilers) to be used by the ProfilerPresenter
"
Class {
	#name : #TallyUI,
	#superclass : #Object,
	#instVars : [
		'tallyObject',
		'profilerUI'
	],
	#category : #ProfilerUI
}

{ #category : #accessing }
TallyUI >> printOn: aStream [
	tallyObject printOn: aStream
	"aStream
		print: tallyObject class;
		nextPutAll: '>>';
		print:
			(tallyObject method ifNotNil: [ tallyObject method selector ])"
]

{ #category : #accessing }
TallyUI >> profilerUI [

	^ profilerUI
]

{ #category : #accessing }
TallyUI >> profilerUI: anObject [

	profilerUI := anObject
]

{ #category : #querying }
TallyUI >> sons [

	^ (tallyObject sonsOver: profilerUI threshold) collect: [ :each | 
		  each asTallyUI
			  profilerUI: profilerUI;
			  yourself ]
]

{ #category : #accessing }
TallyUI >> tally [
	^ tallyObject tally
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
	^ (self weight * self profilerUI totalTime / 100) 
]

{ #category : #accessing }
TallyUI >> weight [ 
	^ self tally asFloat / profilerUI total * 100.0
]
