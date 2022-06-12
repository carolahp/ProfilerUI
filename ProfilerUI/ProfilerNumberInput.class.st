"
I am a number input text to introduce percentage threshold to filter / expand / collapse in the profiler results tree
"
Class {
	#name : #ProfilerNumberInput,
	#superclass : #SpNumberInputFieldPresenter,
	#category : #'ProfilerUI-View'
}

{ #category : #initialization }
ProfilerNumberInput >> initialize [

	super initialize.
	self
		beFloat;
		digits: 1;
		climbRate: 0.5;
		minimum: 0;
		maximum: 100
]

{ #category : #initialization }
ProfilerNumberInput >> initializePresenters [
	self eventHandler
		whenFocusLostDo: [
			self number isZero ifTrue: [ self number: 0 ].
			self acceptText: self number asString ];
		whenFocusReceivedDo: [ self selectAll ];
		whenMouseDownDo: [ :evt | self selectAll ].

]
