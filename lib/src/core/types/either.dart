import 'package:meta/meta.dart';

///[Either] abstract class that contains
///generics [TLeft] and [TRight]
abstract class Either<TLeft, TRight> {
  /// The get [isLeft] it's the type boolean
  bool get isLeft;

  /// The get [isRight] it's the type boolean
  bool get isRight;

  ///The method [fold] it's the type [T] generics and recive for params
  ///the functions [leftFn] and [rightFn].
  T fold<T>(T Function(TLeft l) leftFn, T Function(TRight r) rightFn);

  ///The method [getOrElse] it's the type [TRight] and recive for params
  ///the function [orElse].
  TRight getOrElse(TRight Function(TLeft left) orElse);

  ///The method [bind] it's the type Either<TLeft, T>, recive for
  ///params the function [fn] and return [fold] (left, fn).
  Either<TLeft, T> bind<T>(Either<TLeft, T> Function(TRight r) fn) {
    return fold(left, fn);
  }

  ///The method [asyncBind] it's the type Future<Either<TLeft, T>>,
  ///recive for params the function [fn] and return
  ///[fold] ((l) async => left(l), fn).
  Future<Either<TLeft, T>> asyncBind<T>(
    Future<Either<TLeft, T>> Function(TRight r) fn,
  ) {
    return fold((l) async => left(l), fn);
  }

  ///The method [leftBind] it's the type Either<T, TRight>,
  ///recive for params the function [fn] and return
  ///[fold] (fn, right).
  Either<T, TRight> leftBind<T>(Either<T, TRight> Function(TLeft l) fn) {
    return fold(fn, right);
  }

  ///The method [map] it's the type Either<TLeft, T>,
  ///recive for params the function [fn] and return
  ///[fold] (left, (r) => right(fn(r))).
  Either<TLeft, T> map<T>(T Function(TRight r) fn) {
    return fold(left, (r) => right(fn(r)));
  }

  ///The method [leftMap] it's the type Either<T, TRight>,
  ///recive for params the function [fn] and return
  ///[fold] ((l) => left(fn(l)), right).
  Either<T, TRight> leftMap<T>(T Function(TLeft l) fn) {
    return fold((l) => left(fn(l)), right);
  }
}

class _Left<TLeft, TRight> extends Either<TLeft, TRight> {
  final TLeft _value;

  @override
  final bool isLeft = true;

  @override
  final bool isRight = false;

  _Left(this._value);

  @override
  T fold<T>(T Function(TLeft l) leftFn, T Function(TRight r) rightFn) {
    return leftFn(_value);
  }

  @override
  TRight getOrElse(TRight Function(TLeft l) orElse) {
    return orElse(_value);
  }
}

class _Right<TLeft, TRight> extends Either<TLeft, TRight> {
  final TRight _value;

  @override
  final bool isLeft = false;

  @override
  final bool isRight = true;

  _Right(this._value);

  @override
  T fold<T>(T Function(TLeft l) leftFn, T Function(TRight r) rightFn) {
    return rightFn(_value);
  }

  @override
  TRight getOrElse(TRight Function(TLeft l) orElse) {
    return _value;
  }
}

///The function [right] it's the type Either<TLeft, TRight>,
///recive for params [r] and return
///_Right<TLeft, TRight>(r).
Either<TLeft, TRight> right<TLeft, TRight>(
  TRight r,
) =>
    _Right<TLeft, TRight>(r);

///The function [left] it's the type Either<TLeft, TRight>,
///recive for params [l] and return
///_Left<TLeft, TRight>(l).
Either<TLeft, TRight> left<TLeft, TRight>(TLeft l) => _Left<TLeft, TRight>(l);

///The function [id] it's the type [T] generics,
///recive for params [value] and return [value]

T id<T>(T value) => value;

///[Unit] abstract class
@sealed
abstract class Unit {}

class _Unit implements Unit {
  const _Unit();
}

///The variable [unit] recive _Unit
const unit = _Unit();
