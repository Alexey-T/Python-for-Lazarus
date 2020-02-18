print ('Current value of var test is: ', test)
test.Value = 'New value set by Python'
print ('New value is:', test)
print ('-----------------------------------------------------')
class C:
  def __init__(Self, Arg):
    Self.Arg = Arg
  def __str__(Self):
    return '<C instance contains: ' + str(Self.Arg) + '>'
print ('Current value of var object is: ', object)
object.Value = C('Hello !')
print ('New value is:', object)
