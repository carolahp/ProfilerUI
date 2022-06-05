"
I am an abstract adapter for tallies (from different system profilers) to be used by the ProfilerPresenter
"
Class {
	#name : #TallyModel,
	#superclass : #Object,
	#instVars : [
		'tallyObject',
		'profilerModel'
	],
	#category : #'ProfilerUI-Model'
}

{ #category : #accessing }
TallyModel >> data [
	^ self
]

{ #category : #'collecting leaves' }
TallyModel >> leavesInto: aCollection fromSender: anObject [ 
	^ tallyObject leavesInto: aCollection fromSender: anObject
]

{ #category : #accessing }
TallyModel >> methodName [

	^ tallyObject methodClassName , '>>' , (tallyObject method
		   ifNotNil: [ tallyObject method selector ]
		   ifNil: [ '' ])
]

{ #category : #printing }
TallyModel >> printOn: aStream [
	tallyObject printOn: aStream
	"aStream
		print: tallyObject class;
		nextPutAll: '>>';
		print:
			(tallyObject method ifNotNil: [ tallyObject method selector ])"
]

{ #category : #accessing }
TallyModel >> profilerModel [

	^ profilerModel
]

{ #category : #accessing }
TallyModel >> profilerModel: anObject [

	profilerModel := anObject
]

{ #category : #querying }
TallyModel >> reportString [

	^ (self weight printShowingDecimalPlaces: 1) , '% {'
	  , (self time printShowingDecimalPlaces: 1) , 'ms} ' , self methodName
]

{ #category : #querying }
TallyModel >> sons [

	^ (tallyObject sonsOver: profilerModel threshold) collect: [ :each | 
		  each asTallyModel
			  profilerModel: profilerModel;
			  yourself ]
]

{ #category : #accessing }
TallyModel >> tally [
	^ tallyObject tally
]

{ #category : #accessing }
TallyModel >> tallyObject [

	^ tallyObject
]

{ #category : #accessing }
TallyModel >> tallyObject: anObject [

	tallyObject := anObject
]

{ #category : #accessing }
TallyModel >> time [
	^ (self weight * self profilerModel totalTime / 100) 
]

{ #category : #accessing }
TallyModel >> weight [ 
	^ self tally asFloat / profilerModel total * 100.0
]
