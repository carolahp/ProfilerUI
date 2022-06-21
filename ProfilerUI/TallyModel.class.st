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

{ #category : #comparing }
TallyModel >> <= aTallyModelAndreas [ 
	^ self tallyObject tally <= aTallyModelAndreas tallyObject tally
]

{ #category : #transforming }
TallyModel >> asTallyModel [
	^ self
]

{ #category : #accessing }
TallyModel >> data [
	^ self
]

{ #category : #'collecting leaves' }
TallyModel >> leavesInto: aCollection fromSender: anObject [

	tallyObject leavesInto: aCollection fromSender: anObject.
	aCollection associationsDo: [ :assoc | 
		assoc value: (assoc value asTallyModel
				 profilerModel: profilerModel;
				 yourself) ]
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

	^ (self weightToRoot printShowingDecimalPlaces: 1) , '% {'
	  , (self time printShowingDecimalPlaces: 1) , 'ms} ' , self methodName
]

{ #category : #querying }
TallyModel >> sons [

	^ self sonsOver: 0
]

{ #category : #accessing }
TallyModel >> sonsOver: perCent [ 
	| threshold |
	threshold := (perCent asFloat / 100 * tallyObject tally) rounded.
	^ (tallyObject sonsOver: threshold) collect: [ :each | 
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
	^ self tally asFloat / profilerModel totalTally * 100.0
]

{ #category : #accessing }
TallyModel >> weightToRoot [  

	^ self tally asFloat / profilerModel tallyRoot tally * 100.0
]
