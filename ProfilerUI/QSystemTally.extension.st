Extension { #name : #QSystemTally }

{ #category : #'*ProfilerUI' }
QSystemTally >> asTallyModel [
	^ TallyModelAndreas new
		tallyObject: self;
		yourself
]
