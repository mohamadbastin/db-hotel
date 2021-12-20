import 'package:db_hotel/db/room_status/room_status_model.dart';
import 'package:db_hotel/db/room_type/room_type_model.dart';
import 'package:floor/floor.dart';

@Entity(foreignKeys: [
  ForeignKey(
      childColumns: ['type'],
      parentColumns: ['id'],
      entity: RoomType,
      onDelete: ForeignKeyAction.cascade),
  ForeignKey(
      childColumns: ['status'],
      parentColumns: ['id'],
      entity: RoomStatus,
      onDelete: ForeignKeyAction.cascade),
])
class Room {
  Room(
      {required this.floor,
      required this.price,
      this.capacity = 3,
      required this.type,
      this.status = 1});

  @PrimaryKey(autoGenerate: true)
  int? id;
  int floor;
  int price;
  int capacity;
  int type;
  int status;
}