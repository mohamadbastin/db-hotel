import 'package:db_hotel/db/bill/bill_model.dart';
import 'package:db_hotel/db/booking_status/booking_status_model.dart';
import 'package:db_hotel/db/guest/guest_model.dart';
import 'package:db_hotel/db/people/people_model.dart';
import 'package:db_hotel/db/staff/staff_model.dart';
import 'package:floor/floor.dart';

@Entity(foreignKeys: [
  ForeignKey(
      childColumns: ["bookingStatus"],
      parentColumns: ["id"],
      entity: BookingStatus),
  ForeignKey(childColumns: ["staff"], parentColumns: ["id"], entity: Staff),
  ForeignKey(childColumns: ["bill"], parentColumns: ["id"], entity: Bill),
  ForeignKey(childColumns: ["guest"], parentColumns: ["id"], entity: Guest),
])
class Reservation {
  Reservation(
      {this.id,
      required this.guest,
      required this.reserveDate,
      this.checkInDate,
      this.checkOutDate,
      this.noNights,
      required this.bookingStatus,
      this.staff = 1,
      this.bill});

  @PrimaryKey(autoGenerate: true)
  int? id;
  String reserveDate;
  String? checkInDate;
  String? checkOutDate;
  int? noNights;
  int bookingStatus;
  int? staff;
  int? bill;
  int guest;
}

// 'CREATE TABLE IF NOT EXISTS `Reservation`
// (`id` INTEGER PRIMARY KEY AUTOINCREMENT,
// `reserveDate` TEXT NOT NULL,
// `checkInDate` TEXT, `checkOutDate` TEXT,
// `noNights` INTEGER, `bookingStatus` INTEGER NOT NULL,
// `staff` INTEGER,
// `guest` INTEGER NOT NULL,
// FOREIGN KEY (`bookingStatus`) REFERENCES `BookingStatus` (`id`)
// ON UPDATE NO ACTION ON DELETE NO ACTION,
// FOREIGN KEY (`staff`) REFERENCES `Staff` (`id`)
// ON UPDATE NO ACTION ON DELETE NO ACTION,
// FOREIGN KEY (`bill`) REFERENCES `Bill` (`id`)
// ON UPDATE NO ACTION ON DELETE NO ACTION,
// FOREIGN KEY (`guest`) REFERENCES `Guest` (`id`)
// ON UPDATE NO ACTION ON DELETE NO ACTION)'
