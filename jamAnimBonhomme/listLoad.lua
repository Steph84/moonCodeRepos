--RAF cheveux, genoux, coudes, pieds, mains, retournement, trajectoire mecanique du point


-- proportion human body
body =  {}
body.pixel = 30
body.head = 1
body.nose = 0.1
body.torso = 3
body.legs = 4
body.arms = 2
body.hands = 0.5
body.feet = 0.5
body.radius = body.pixel
body.bottomY = 0

ground = {}
ground.x = 0
ground.y = 0
ground.width = 0
ground.height = 50
ground.offset = 10

torso = {}
torso.x = 0
torso.y = 0
torso.width = 0
torso.height = 0

legs = {}
legs.width = 0
legs.height = 0

legsLeft = {}
legsLeft.x = 0
legsLeft.y = 0
legsLeft.width = 0
legsLeft.height = 0

legsRight = {}
legsRight.x = 0
legsRight.y = 0
legsRight.width = 0
legsRight.height = 0

arms = {}
arms.width = 0
arms.height = 0

armsLeft = {}
armsLeft.x = 0
armsLeft.y = 0
armsLeft.width = 0
armsLeft.height = 0

armsRight = {}
armsRight.x = 0
armsRight.y = 0
armsRight.width = 0
armsRight.height = 0

head = {}
head.radius = 0
head.x = 0
head.y = 0

nose = {}
nose.radius = 0
nose.x = 0
nose.y = 0

moving = {}
moving.onTheGround = true
moving.onTheWalk = false
moving.onTheRun = false
moving.onTheJump = false
moving.onTheCrouch = false
moving.standStill = true

moving.angleScissor = 0
moving.speedScissorWalk = 0.01
moving.speedScissorRun = 0.05
moving.speedScissorJump = 2.0

moving.maxAngleWalk = 0.4
moving.maxAngleRun = 0.9
moving.maxAngleJump = 1.2

moving.thresholdStill = 0.05

moving.supportingFoot = "left"
moving.rightLegTo = "right"
moving.rightArmTo = "left"

moving.speedWalk = 3
moving.speedRun = 9
moving.speedJump = 7
