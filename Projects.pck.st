'From Cuis 5.0 of 7 November 2016 [latest update: #3397] on 11 October 2018 at 5:58:34 pm'!
'Description Create hierarchical projects similar to those in the original Smalltalk-80 system. '!
!provides: 'Projects' 1 3!
SystemOrganization addCategory: #Projects!


!classDefinition: #ScalableImageMorph category: #Projects!
ImageMorph subclass: #ScalableImageMorph
	instanceVariableNames: 'scaledImage originalImage'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Projects'!
!classDefinition: 'ScalableImageMorph class' category: #Projects!
ScalableImageMorph class
	instanceVariableNames: ''!

!classDefinition: #ProjectMorph category: #Projects!
PluggableMorph subclass: #ProjectMorph
	instanceVariableNames: 'aScalableImageMorph'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Projects'!
!classDefinition: 'ProjectMorph class' category: #Projects!
ProjectMorph class
	instanceVariableNames: ''!

!classDefinition: #Project category: #Projects!
Object subclass: #Project
	instanceVariableNames: 'parentProject world thumbnail'
	classVariableNames: 'CurrentProject'
	poolDictionaries: ''
	category: 'Projects'!
!classDefinition: 'Project class' category: #Projects!
Project class
	instanceVariableNames: 'transcript'!


!ScalableImageMorph methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 17:14:38'!
image: anImage 
	originalImage _ anImage.
	super image: anImage.
! !

!ScalableImageMorph methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 14:46:47'!
minimumExtent
	^0@0! !

!ScalableImageMorph methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 17:18:10'!
morphExtent: aPoint
	extent _ aPoint. 
	self someSubmorphPositionOrExtentChanged! !

!ScalableImageMorph methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 17:09:36'!
someSubmorphPositionOrExtentChanged
		image _ originalImage magnifyTo: extent.
! !

!ProjectMorph methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 16:01:18'!
handlesMouseDown: aMouseButtonEvent
	^ aMouseButtonEvent mouseButton1Pressed ! !

!ProjectMorph methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 16:52:16'!
initialize

	| |
	
	super initialize.
	
	aScalableImageMorph _ ScalableImageMorph new.

	aScalableImageMorph morphExtent: self morphExtent.
	
	self addMorph: aScalableImageMorph.
		
"	layoutMorph _ LayoutMorph newColumn.

	self addMorphFront: layoutMorph.
	layoutMorph addMorph:aScalableImageMorph proportionalHeight: 1."
! !

!ProjectMorph methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 17:31:40'!
model: aProject

	super model: aProject.
	
	"aScalableImageMorph image: model thumbnail. "
	
	model when:#changed send:#update to:self 
! !

!ProjectMorph methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 17:30:16'!
mouseButton1Up: aMouseButtonEvent localPosition: localEventPosition
	model enter! !

!ProjectMorph methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 17:08:15'!
someSubmorphPositionOrExtentChanged
	submorphs do:[ :each | each morphExtent: extent ].! !

!ProjectMorph methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 16:42:38'!
update
	aScalableImageMorph image: model thumbnail.! !

!ProjectMorph class methodsFor: 'as yet unclassified' stamp: 'DF 10/8/2018 15:06:48'!
open

	| aProject aProjectMorph |
	
	aProject _ Project new.
	aProjectMorph _ ProjectMorph new.
	aProjectMorph model: aProject.
	
	^(aProjectMorph embeddedInMorphicWindowLabeled: 'Unnamed') openInWorld
! !

!Project methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 16:15:18'!
enter

	CurrentProject ifNotNil:[CurrentProject leave].
	CurrentProject _ self.
	
	[ActiveModel flushEventSystem.
	UISupervisor stopUIProcess.
	UISupervisor spawnNewMorphicProcessFor: world.
	Display triggerEvent: #screenSizeChanged] fork 

! !

!Project methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 11:51:41'!
initialize
	parentProject _ CurrentProject.
	
	" the root project (the only project with a nil parent) binds to the existing world. All other projects create a new world."
	
	parentProject 
		ifNil:[ world _ UISupervisor ui ]
		ifNotNil:[	world _ UISupervisor ui class newWorld ].! !

!Project methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 17:29:31'!
leave
	thumbnail _ Form fromDisplay: (0@0 extent:Display extent).
	self triggerEvent: #changed.! !

!Project methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 10:53:02'!
parent
	^parentProject! !

!Project methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 16:20:00'!
thumbnail
	^thumbnail! !

!Project class methodsFor: 'as yet unclassified' stamp: 'DF 8/8/2018 11:53:40'!
current
	^CurrentProject! !

!Project class methodsFor: 'as yet unclassified' stamp: 'DF 10/11/2018 17:58:21'!
initialize
	CurrentProject _ Project new! !

!TheWorldMenu methodsFor: '*Projects' stamp: 'DF 10/8/2018 15:08:27'!
newProject
	ProjectMorph open morphExtent:300@200! !

!TheWorldMenu methodsFor: '*Projects' stamp: 'DF 8/8/2018 17:46:02'!
previousProject

	| previousProject | 
	
	previousProject _ Project current parent.
	
	previousProject 
		ifNotNil:[ previousProject enter]! !
Project initialize!
