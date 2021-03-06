import 'dart:developer';

import 'package:db_hotel/db/booking_status/booking_status_model.dart';
import 'package:db_hotel/db/food/food_model.dart';
import 'package:db_hotel/db/food_order_relation/food_order_relation_model.dart';
import 'package:db_hotel/db/order/order_model.dart';
import 'package:db_hotel/db/reservation/reservation_model.dart';
import 'package:db_hotel/db/reservation_details/reservation_details_model.dart';
import 'package:db_hotel/db/resturant_coffee_shop/resturant_coffeeshop_model.dart';
import 'package:db_hotel/db/room_status/room_status_model.dart';
import 'package:db_hotel/db/room_type/room_type_model.dart';
import 'package:db_hotel/db/staff/staff_model.dart';
import 'package:db_hotel/screens/first_screen/first_screen.dart';
import 'package:flutter/material.dart';

import 'db/database.dart';
import 'db/room/room_model.dart';

void main() async {
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  dbUtil(database);
  // deleteReservations(database);
  // deleteOrders(database);
  runApp(MyApp(
    database: database,
  ));
}

void deleteReservations(AppDatabase database) async {
  final List<ReservationDetails>? rds =
      await database.reservationDetailDao.getAll();
  int l = await database.reservationDetailDao.deleteReservationDetails(rds!);

  final List<Reservation>? rs = await database.reservationDao.getAll();
  int rl = await database.reservationDao.deleteReservations(rs!);

  final List<Room> rooms = await database.roomDao.getAll();
  RoomStatus? b1 =
      await database.roomStatusDao.getRoomStatusByName("Available");
  RoomStatus? b3 =
      await database.roomStatusDao.getRoomStatusByName("Out of Order");

  for (Room i in rooms) {
    if (i.floor == 3) {
      i.status = b3!.id!;
    } else {
      i.status = b1!.id!;
    }
    // print(i.status);
  }
  int r = await database.roomDao.updateRooms(rooms);
  log("lines deleted rd: $l, res: $rl, rooms: $r", name: "DELETE_DB");
}

void deleteOrders(AppDatabase database) async {
  final List<FoodOrderRelation> a =
      await database.foodOrderRelationDao.getAll();
  final int aa =
      await database.foodOrderRelationDao.deleteFoodOrderRelations(a);
  final List<Order> rds = await database.orderDao.getAll();

  int l = await database.orderDao.deleteOrders(rds);
  log("lines deleted rd:  $aa, $l", name: "DELETE_DB");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.database}) : super(key: key);
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstScreen(
        database: database,
      ),
    );
  }
}

void dbUtil(AppDatabase db) async {
  RoomType? a1 = await db.roomTypeDao.getRoomTypeByName("One Bed");
  if (a1 == null) {
    db.roomTypeDao.insertRoomType(
        RoomType(name: "One Bed", numberOfBeds: 1, image: "image"));
  }
  RoomType? a2 = await db.roomTypeDao.getRoomTypeByName("Two Bed");
  if (a2 == null) {
    db.roomTypeDao.insertRoomType(
        RoomType(name: "Two Bed", numberOfBeds: 2, image: "image"));
  }
  RoomType? a3 = await db.roomTypeDao.getRoomTypeByName("Three Bed");
  if (a3 == null) {
    db.roomTypeDao.insertRoomType(
        RoomType(name: "Three Bed", numberOfBeds: 3, image: "image"));
  }

  RoomStatus? b1 = await db.roomStatusDao.getRoomStatusByName("Available");
  if (b1 == null) {
    db.roomStatusDao.insertRoomStatus(RoomStatus(name: "Available"));
  }
  RoomStatus? b2 = await db.roomStatusDao.getRoomStatusByName("Full");
  if (b2 == null) {
    db.roomStatusDao.insertRoomStatus(RoomStatus(name: "Full"));
  }
  RoomStatus? b3 = await db.roomStatusDao.getRoomStatusByName("Out of Order");
  if (b3 == null) {
    db.roomStatusDao.insertRoomStatus(RoomStatus(name: "Out of Order"));
  }

  BookingStatus? c1 =
      await db.bookingStatusDao.getBookingStatusByName("Approved");
  if (c1 == null) {
    db.bookingStatusDao.insertBookingStatus(BookingStatus(name: "Approved"));
  }
  BookingStatus? c2 =
      await db.bookingStatusDao.getBookingStatusByName("Declined");
  if (c2 == null) {
    db.bookingStatusDao.insertBookingStatus(BookingStatus(name: "Declined"));
  }
  BookingStatus? c3 =
      await db.bookingStatusDao.getBookingStatusByName("Waiting");
  if (c3 == null) {
    db.bookingStatusDao.insertBookingStatus(BookingStatus(name: "Waiting"));
  }

  RoomType? roomTypeOneBed = await db.roomTypeDao.getRoomTypeByName("One Bed");
  RoomType? roomTypeTwoBed = await db.roomTypeDao.getRoomTypeByName("Two Bed");
  RoomType? roomTypeThreeBed =
      await db.roomTypeDao.getRoomTypeByName("Three Bed");

  RoomStatus? roomStatusAvailable =
      await db.roomStatusDao.getRoomStatusByName("Available");
  RoomStatus? roomStatusFull =
      await db.roomStatusDao.getRoomStatusByName("Full");
  RoomStatus? roomStatusOutOfOrder =
      await db.roomStatusDao.getRoomStatusByName("Out of Order");

  log("room type one bed: ${roomTypeOneBed!.id}", name: "DB UTIL");

  Room? r1 = await db.roomDao.getRoomByID(1);
  Room? r10 = await db.roomDao.getRoomByID(10);

  // if (r1 == null && r10 == null) {
  //   db.roomDao.insertRoom(Room(
  //       number: 1,
  //       floor: 1,
  //       price: 50,
  //       type: roomTypeOneBed.id!,
  //       status: roomStatusAvailable!.id!));
  //   db.roomDao.insertRoom(Room(
  //       number: 2,
  //       floor: 1,
  //       price: 60,
  //       type: roomTypeTwoBed!.id!,
  //       status: roomStatusAvailable.id!));
  //   db.roomDao.insertRoom(Room(
  //       number: 3,
  //       floor: 1,
  //       price: 70,
  //       type: roomTypeThreeBed!.id!,
  //       status: roomStatusAvailable.id!));
  //   db.roomDao.insertRoom(Room(
  //       number: 4,
  //       floor: 2,
  //       price: 50,
  //       type: roomTypeOneBed.id!,
  //       status: roomStatusAvailable.id!));
  //   db.roomDao.insertRoom(Room(
  //       number: 5,
  //       floor: 2,
  //       price: 60,
  //       type: roomTypeTwoBed.id!,
  //       status: roomStatusAvailable.id!));
  //   db.roomDao.insertRoom(Room(
  //       number: 6,
  //       floor: 2,
  //       price: 70,
  //       type: roomTypeThreeBed.id!,
  //       status: roomStatusAvailable.id!));
  //   db.roomDao.insertRoom(Room(
  //       number: 7,
  //       floor: 3,
  //       price: 50,
  //       type: roomTypeOneBed.id!,
  //       status: roomStatusFull!.id!));
  //   db.roomDao.insertRoom(Room(
  //       number: 8,
  //       floor: 3,
  //       price: 60,
  //       type: roomTypeTwoBed.id!,
  //       status: roomStatusFull.id!));
  //   db.roomDao.insertRoom(Room(
  //       number: 9,
  //       floor: 3,
  //       price: 70,
  //       type: roomTypeThreeBed.id!,
  //       status: roomStatusFull.id!));
  //   db.roomDao.insertRoom(Room(
  //       number: 10,
  //       floor: 4,
  //       price: 50,
  //       type: roomTypeOneBed.id!,
  //       status: roomStatusOutOfOrder!.id!));
  //   db.roomDao.insertRoom(Room(
  //       number: 11,
  //       floor: 4,
  //       price: 60,
  //       type: roomTypeTwoBed.id!,
  //       status: roomStatusAvailable.id!));
  // }

  Staff? s1 = await db.staffDao.getStaffByID(1);
  if (s1 == null) {
    Staff s1 = Staff(password: "1", name: "admin", nationalId: "1", email: "a");
    await db.staffDao.insertStaff(s1);
  }

  Staff? s2 = await db.staffDao.getStaffByID(2);
  if (s2 == null) {
    Staff s2 =
        Staff(password: "1", name: "staff1", nationalId: "11", email: "aa");
    await db.staffDao.insertStaff(s2);
  }

  Staff? s3 = await db.staffDao.getStaffByID(3);
  if (s3 == null) {
    Staff s3 = Staff(
        password: "1", name: "staff2", nationalId: "12", email: "aa", role: 1);
    await db.staffDao.insertStaff(s3);
  }

  List<RestaurantCoffeeShop> rc1 = await db.restaurantDao.getAll();
  if (rc1.isEmpty) {
    RestaurantCoffeeShop rc = RestaurantCoffeeShop(name: "Lavia", type: 0);
    RestaurantCoffeeShop rc2 = RestaurantCoffeeShop(name: "Gisha", type: 1);
    RestaurantCoffeeShop rc3 = RestaurantCoffeeShop(name: "Zaver", type: 0);
    await db.restaurantDao.insertRestaurant(rc);
    await db.restaurantDao.insertRestaurant(rc2);
    await db.restaurantDao.insertRestaurant(rc3);
  }

  List<Food> fs = await db.foodDao.getAll();
  if (fs.isEmpty) {
    RestaurantCoffeeShop? lavia =
        await db.restaurantDao.getRestaurantByName("Lavia");
    RestaurantCoffeeShop? gisha =
        await db.restaurantDao.getRestaurantByName("Gisha");
    RestaurantCoffeeShop? zaver =
        await db.restaurantDao.getRestaurantByName("Zaver");
    log("zavers id is ${zaver!.id}");
    Food f1 =
        Food(name: "Cheese burger", price: 50, shopId: lavia!.id!, type: 0);
    Food f2 = Food(name: "King burger", price: 70, shopId: lavia.id!, type: 0);
    Food f3 = Food(name: "Fries", price: 30, shopId: lavia.id!, type: 0);
    Food f4 =
        Food(name: "Hot Chocolate", price: 30, shopId: gisha!.id!, type: 1);
    Food f5 = Food(name: "Cappuccino", price: 30, shopId: gisha.id!, type: 1);
    Food f6 = Food(name: "Cake", price: 20, shopId: gisha.id!, type: 0);
    Food f7 = Food(name: "Canol", price: 120, shopId: zaver.id!, type: 0);
    Food f8 = Food(name: "Pepperoni", price: 100, shopId: zaver.id!, type: 0);

    await db.foodDao.insertFood(f1);
    await db.foodDao.insertFood(f2);
    await db.foodDao.insertFood(f3);
    await db.foodDao.insertFood(f4);
    await db.foodDao.insertFood(f5);
    await db.foodDao.insertFood(f6);
    await db.foodDao.insertFood(f7);
    await db.foodDao.insertFood(f8);
  }
}
