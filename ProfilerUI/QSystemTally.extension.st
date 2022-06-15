Extension { #name : #QSystemTally }

{ #category : #'*ProfilerUI' }
QSystemTally >> asTallyModel [
	^ TallyModelAndreas new
		tallyObject: self;
		yourself
]

{ #category : #'*ProfilerUI' }
QSystemTally >> methodClassName [
	^ class ifNil: [ '' ] ifNotNil: [ class name ] 
]
