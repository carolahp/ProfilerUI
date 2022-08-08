"
I am an adapter for tallies from TimeProfiler
"
Class {
	#name : #TallyModelTime,
	#superclass : #TallyModel,
	#category : #'ProfilerUI-Model'
}

{ #category : #accessing }
TallyModelTime >> methodName [

	^ item method class asString, '>>' , (item method
		   ifNotNil: [ item method selector ]
		   ifNil: [ 'nil' ])
]
