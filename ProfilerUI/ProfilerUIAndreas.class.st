Class {
	#name : #ProfilerUIAndreas,
	#superclass : #ProfilerUI,
	#category : #ProfilerUI
}

{ #category : #'accessing - computed' }
ProfilerUIAndreas >> rootTallyItems [
	^ self tallyRoot sons
]

{ #category : #'accessing - computed' }
ProfilerUIAndreas >> startProfiling [
	^ profiler startProfiling
]

{ #category : #'accessing - computed' }
ProfilerUIAndreas >> stopProfiling [
	^ profiler stopProfiling
]
