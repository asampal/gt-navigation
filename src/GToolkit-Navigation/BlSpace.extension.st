Extension { #name : #BlSpace }

{ #category : #'*GToolkit-Navigation' }
BlSpace >> withNavigation [
	self root addEventFilter: GtNavigationEventFilter new
]
