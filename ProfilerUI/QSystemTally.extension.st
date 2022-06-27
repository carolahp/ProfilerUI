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

{ #category : #'*ProfilerUI' }
QSystemTally >> methodOrBlock [
	^ method
]

{ #category : #'*ProfilerUI' }
QSystemTally >> originMethod [
	| methodOrBlock |
	methodOrBlock := self methodOrBlock.
	^ methodOrBlock isCompiledBlock
		  ifTrue: [ methodOrBlock method ]
		  ifFalse: [ methodOrBlock ]
]
