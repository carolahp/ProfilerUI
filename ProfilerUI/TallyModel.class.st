"
I am an abstract adapter for tallies (from different system profilers) to be used by the ProfilerPresenter
"
Class {
	#name : #TallyModel,
	#superclass : #MorphTreeNodeModel,
	#category : #'ProfilerUI-Model'
}

{ #category : #comparing }
TallyModel >> <= aTallyModelAndreas [ 
	^ self item tally <= aTallyModelAndreas item tally
]

{ #category : #converting }
TallyModel >> asString [
	^ self reportString
]

{ #category : #transforming }
TallyModel >> asTallyModel [
	^ self
]

{ #category : #actions }
TallyModel >> browseItem [
	self item originMethod browse
]

{ #category : #accessing }
TallyModel >> childrenItems [
	| perCent threshold |
	
	perCent := model showNodeThreshold.
	threshold := (perCent asFloat / 100 * model tallyRoot tally) rounded.
	
	^ (self item sonsOver: threshold) asSortedCollection reverse
]

{ #category : #accessing }
TallyModel >> data [
	^ self
]

{ #category : #actions }
TallyModel >> exploreItem [
	self item inspect
]

{ #category : #accessing }
TallyModel >> icon [
	^ nil
	
	"| methodOrBlock |
	methodOrBlock := tallyObject methodOrBlock.
	^ Smalltalk ui icons iconNamed: (methodOrBlock isCompiledBlock
			   ifTrue: [ #smallLeftFlush ]
			   ifFalse: [ 
				   methodOrBlock isPrimitive
					   ifTrue: [ #transcript ]
					   ifFalse: [ #workspace ] ])"
]

{ #category : #actions }
TallyModel >> inspectItem [
	self inspect
]

{ #category : #'event handling' }
TallyModel >> keyDown: anEvent from: aTreeMorph [
	| c |
	c := anEvent keyCharacter.
	c = $b
		ifTrue: [self browseItem. ^ true].
	c = $i
		ifTrue: [self inspectItem. ^ true].
	c = $I
		ifTrue: [self exploreItem. ^ true].
	^ false
]

{ #category : #'collecting leaves' }
TallyModel >> leavesInto: aCollection fromSender: anObject [

	item leavesInto: aCollection fromSender: anObject.
	aCollection associationsDo: [ :assoc | 
		assoc value: (assoc value asTallyModel
				 model: model;
				 yourself) ]
]

{ #category : #menu }
TallyModel >> menu: menu shifted: b [ 
	menu
		add: 'Browse (b)'
		target: self
		selector: #browseItem.
	menu
		add: 'Inspect (i)'
		target: self
		selector: #inspectItem.
	menu
		add: 'Explore (I)'
		target: self
		selector: #exploreItem.

]

{ #category : #accessing }
TallyModel >> methodName [

	^ item methodClassName , '>>' , (item method
		   ifNotNil: [ item method selector ]
		   ifNil: [ 'nil' ])
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
TallyModel >> sonsOver: minTally [ 
	^ (item sonsOver: minTally) collect: [ :each | 
		  each asTallyModel
			  model: model;
			  yourself ]
]

{ #category : #accessing }
TallyModel >> tally [
	^ item tally
]

{ #category : #accessing }
TallyModel >> time [
	^ (self weight * self model totalTime / 100) 
]

{ #category : #accessing }
TallyModel >> weight [ 
	^ self tally asFloat / model totalTally * 100.0
]

{ #category : #accessing }
TallyModel >> weightToRoot [  

	^ self tally asFloat / model tallyRoot tally * 100.0
]
