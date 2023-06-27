abstract class Schedule{
  void work();

  factory Schedule(String type){
    switch (type) {
      case 'Morning':
        return Morning();
      case 'Afternoon':
        return Afternoon();
      case 'Evening':
        return Evening();
      default:
        return Morning();
    }
  }
}

class Morning implements Schedule {
  @override
  void work(){
    print('This note is scheduled for Morning');
  }
}
class Afternoon implements Schedule {
  @override
  void work(){
    print('This note is scheduled for Afternoon');
  }
}
class Evening implements Schedule {
  @override
  void work(){
    print('This note is scheduled for Evening');
  }
}
