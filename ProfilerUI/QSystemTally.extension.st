Extension { #name : #QSystemTally }

{ #category : #'*ProfilerUI' }
QSystemTally >> asTallyUI [
	^ TallyUIAndreas new
		tallyObject: self;
		yourself
]
