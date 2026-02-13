// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBudgetIsarCollection on Isar {
  IsarCollection<BudgetIsar> get budgetIsars => this.collection();
}

const BudgetIsarSchema = CollectionSchema(
  name: r'BudgetIsar',
  id: 5646041003862359881,
  properties: {
    r'salary': PropertySchema(
      id: 0,
      name: r'salary',
      type: IsarType.double,
    )
  },
  estimateSize: _budgetIsarEstimateSize,
  serialize: _budgetIsarSerialize,
  deserialize: _budgetIsarDeserialize,
  deserializeProp: _budgetIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'monthlyBudgets': LinkSchema(
      id: 1581760868570007877,
      name: r'monthlyBudgets',
      target: r'MonthlyBudgetIsar',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _budgetIsarGetId,
  getLinks: _budgetIsarGetLinks,
  attach: _budgetIsarAttach,
  version: '3.3.0',
);

int _budgetIsarEstimateSize(
  BudgetIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _budgetIsarSerialize(
  BudgetIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.salary);
}

BudgetIsar _budgetIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BudgetIsar();
  object.id = id;
  object.salary = reader.readDouble(offsets[0]);
  return object;
}

P _budgetIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _budgetIsarGetId(BudgetIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _budgetIsarGetLinks(BudgetIsar object) {
  return [object.monthlyBudgets];
}

void _budgetIsarAttach(IsarCollection<dynamic> col, Id id, BudgetIsar object) {
  object.id = id;
  object.monthlyBudgets.attach(
      col, col.isar.collection<MonthlyBudgetIsar>(), r'monthlyBudgets', id);
}

extension BudgetIsarQueryWhereSort
    on QueryBuilder<BudgetIsar, BudgetIsar, QWhere> {
  QueryBuilder<BudgetIsar, BudgetIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BudgetIsarQueryWhere
    on QueryBuilder<BudgetIsar, BudgetIsar, QWhereClause> {
  QueryBuilder<BudgetIsar, BudgetIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BudgetIsarQueryFilter
    on QueryBuilder<BudgetIsar, BudgetIsar, QFilterCondition> {
  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition> salaryEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'salary',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition> salaryGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'salary',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition> salaryLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'salary',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition> salaryBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'salary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension BudgetIsarQueryObject
    on QueryBuilder<BudgetIsar, BudgetIsar, QFilterCondition> {}

extension BudgetIsarQueryLinks
    on QueryBuilder<BudgetIsar, BudgetIsar, QFilterCondition> {
  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition> monthlyBudgets(
      FilterQuery<MonthlyBudgetIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'monthlyBudgets');
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition>
      monthlyBudgetsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'monthlyBudgets', length, true, length, true);
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition>
      monthlyBudgetsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'monthlyBudgets', 0, true, 0, true);
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition>
      monthlyBudgetsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'monthlyBudgets', 0, false, 999999, true);
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition>
      monthlyBudgetsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'monthlyBudgets', 0, true, length, include);
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition>
      monthlyBudgetsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'monthlyBudgets', length, include, 999999, true);
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterFilterCondition>
      monthlyBudgetsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'monthlyBudgets', lower, includeLower, upper, includeUpper);
    });
  }
}

extension BudgetIsarQuerySortBy
    on QueryBuilder<BudgetIsar, BudgetIsar, QSortBy> {
  QueryBuilder<BudgetIsar, BudgetIsar, QAfterSortBy> sortBySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salary', Sort.asc);
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterSortBy> sortBySalaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salary', Sort.desc);
    });
  }
}

extension BudgetIsarQuerySortThenBy
    on QueryBuilder<BudgetIsar, BudgetIsar, QSortThenBy> {
  QueryBuilder<BudgetIsar, BudgetIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterSortBy> thenBySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salary', Sort.asc);
    });
  }

  QueryBuilder<BudgetIsar, BudgetIsar, QAfterSortBy> thenBySalaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'salary', Sort.desc);
    });
  }
}

extension BudgetIsarQueryWhereDistinct
    on QueryBuilder<BudgetIsar, BudgetIsar, QDistinct> {
  QueryBuilder<BudgetIsar, BudgetIsar, QDistinct> distinctBySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'salary');
    });
  }
}

extension BudgetIsarQueryProperty
    on QueryBuilder<BudgetIsar, BudgetIsar, QQueryProperty> {
  QueryBuilder<BudgetIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BudgetIsar, double, QQueryOperations> salaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'salary');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMonthlyBudgetIsarCollection on Isar {
  IsarCollection<MonthlyBudgetIsar> get monthlyBudgetIsars => this.collection();
}

const MonthlyBudgetIsarSchema = CollectionSchema(
  name: r'MonthlyBudgetIsar',
  id: -4048939832659136794,
  properties: {
    r'month': PropertySchema(
      id: 0,
      name: r'month',
      type: IsarType.string,
    ),
    r'year': PropertySchema(
      id: 1,
      name: r'year',
      type: IsarType.string,
    )
  },
  estimateSize: _monthlyBudgetIsarEstimateSize,
  serialize: _monthlyBudgetIsarSerialize,
  deserialize: _monthlyBudgetIsarDeserialize,
  deserializeProp: _monthlyBudgetIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'bankSlips': LinkSchema(
      id: -1467985367965342231,
      name: r'bankSlips',
      target: r'BankSlipIsar',
      single: false,
    ),
    r'budget': LinkSchema(
      id: 100991369402490196,
      name: r'budget',
      target: r'BudgetIsar',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _monthlyBudgetIsarGetId,
  getLinks: _monthlyBudgetIsarGetLinks,
  attach: _monthlyBudgetIsarAttach,
  version: '3.3.0',
);

int _monthlyBudgetIsarEstimateSize(
  MonthlyBudgetIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.month.length * 3;
  bytesCount += 3 + object.year.length * 3;
  return bytesCount;
}

void _monthlyBudgetIsarSerialize(
  MonthlyBudgetIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.month);
  writer.writeString(offsets[1], object.year);
}

MonthlyBudgetIsar _monthlyBudgetIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MonthlyBudgetIsar();
  object.id = id;
  object.month = reader.readString(offsets[0]);
  object.year = reader.readString(offsets[1]);
  return object;
}

P _monthlyBudgetIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _monthlyBudgetIsarGetId(MonthlyBudgetIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _monthlyBudgetIsarGetLinks(
    MonthlyBudgetIsar object) {
  return [object.bankSlips, object.budget];
}

void _monthlyBudgetIsarAttach(
    IsarCollection<dynamic> col, Id id, MonthlyBudgetIsar object) {
  object.id = id;
  object.bankSlips
      .attach(col, col.isar.collection<BankSlipIsar>(), r'bankSlips', id);
  object.budget.attach(col, col.isar.collection<BudgetIsar>(), r'budget', id);
}

extension MonthlyBudgetIsarQueryWhereSort
    on QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QWhere> {
  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MonthlyBudgetIsarQueryWhere
    on QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QWhereClause> {
  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MonthlyBudgetIsarQueryFilter
    on QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QFilterCondition> {
  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      monthEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'month',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      monthGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'month',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      monthLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'month',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      monthBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'month',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      monthStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'month',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      monthEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'month',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      monthContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'month',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      monthMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'month',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      monthIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'month',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      monthIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'month',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      yearEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      yearGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      yearLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      yearBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'year',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      yearStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      yearEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      yearContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      yearMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'year',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      yearIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: '',
      ));
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      yearIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'year',
        value: '',
      ));
    });
  }
}

extension MonthlyBudgetIsarQueryObject
    on QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QFilterCondition> {}

extension MonthlyBudgetIsarQueryLinks
    on QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QFilterCondition> {
  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      bankSlips(FilterQuery<BankSlipIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'bankSlips');
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      bankSlipsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bankSlips', length, true, length, true);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      bankSlipsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bankSlips', 0, true, 0, true);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      bankSlipsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bankSlips', 0, false, 999999, true);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      bankSlipsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bankSlips', 0, true, length, include);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      bankSlipsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'bankSlips', length, include, 999999, true);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      bankSlipsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'bankSlips', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      budget(FilterQuery<BudgetIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'budget');
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterFilterCondition>
      budgetIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'budget', 0, true, 0, true);
    });
  }
}

extension MonthlyBudgetIsarQuerySortBy
    on QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QSortBy> {
  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterSortBy>
      sortByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterSortBy>
      sortByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterSortBy>
      sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterSortBy>
      sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension MonthlyBudgetIsarQuerySortThenBy
    on QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QSortThenBy> {
  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterSortBy>
      thenByMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.asc);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterSortBy>
      thenByMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'month', Sort.desc);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterSortBy>
      thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QAfterSortBy>
      thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension MonthlyBudgetIsarQueryWhereDistinct
    on QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QDistinct> {
  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QDistinct> distinctByMonth(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'month', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QDistinct> distinctByYear(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year', caseSensitive: caseSensitive);
    });
  }
}

extension MonthlyBudgetIsarQueryProperty
    on QueryBuilder<MonthlyBudgetIsar, MonthlyBudgetIsar, QQueryProperty> {
  QueryBuilder<MonthlyBudgetIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MonthlyBudgetIsar, String, QQueryOperations> monthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'month');
    });
  }

  QueryBuilder<MonthlyBudgetIsar, String, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBankSlipIsarCollection on Isar {
  IsarCollection<BankSlipIsar> get bankSlipIsars => this.collection();
}

const BankSlipIsarSchema = CollectionSchema(
  name: r'BankSlipIsar',
  id: 790677297480271481,
  properties: {
    r'categoryId': PropertySchema(
      id: 0,
      name: r'categoryId',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'isPaid': PropertySchema(
      id: 3,
      name: r'isPaid',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'tags': PropertySchema(
      id: 5,
      name: r'tags',
      type: IsarType.string,
    ),
    r'value': PropertySchema(
      id: 6,
      name: r'value',
      type: IsarType.double,
    )
  },
  estimateSize: _bankSlipIsarEstimateSize,
  serialize: _bankSlipIsarSerialize,
  deserialize: _bankSlipIsarDeserialize,
  deserializeProp: _bankSlipIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'monthlyBudget': LinkSchema(
      id: 2048854701500372233,
      name: r'monthlyBudget',
      target: r'MonthlyBudgetIsar',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _bankSlipIsarGetId,
  getLinks: _bankSlipIsarGetLinks,
  attach: _bankSlipIsarAttach,
  version: '3.3.0',
);

int _bankSlipIsarEstimateSize(
  BankSlipIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.date.length * 3;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.tags;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _bankSlipIsarSerialize(
  BankSlipIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.categoryId);
  writer.writeString(offsets[1], object.date);
  writer.writeString(offsets[2], object.description);
  writer.writeBool(offsets[3], object.isPaid);
  writer.writeString(offsets[4], object.name);
  writer.writeString(offsets[5], object.tags);
  writer.writeDouble(offsets[6], object.value);
}

BankSlipIsar _bankSlipIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BankSlipIsar();
  object.categoryId = reader.readLongOrNull(offsets[0]);
  object.date = reader.readString(offsets[1]);
  object.description = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.isPaid = reader.readBool(offsets[3]);
  object.name = reader.readString(offsets[4]);
  object.tags = reader.readStringOrNull(offsets[5]);
  object.value = reader.readDouble(offsets[6]);
  return object;
}

P _bankSlipIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bankSlipIsarGetId(BankSlipIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bankSlipIsarGetLinks(BankSlipIsar object) {
  return [object.monthlyBudget];
}

void _bankSlipIsarAttach(
    IsarCollection<dynamic> col, Id id, BankSlipIsar object) {
  object.id = id;
  object.monthlyBudget.attach(
      col, col.isar.collection<MonthlyBudgetIsar>(), r'monthlyBudget', id);
}

extension BankSlipIsarQueryWhereSort
    on QueryBuilder<BankSlipIsar, BankSlipIsar, QWhere> {
  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BankSlipIsarQueryWhere
    on QueryBuilder<BankSlipIsar, BankSlipIsar, QWhereClause> {
  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BankSlipIsarQueryFilter
    on QueryBuilder<BankSlipIsar, BankSlipIsar, QFilterCondition> {
  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      categoryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'categoryId',
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      categoryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'categoryId',
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      categoryIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      categoryIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      categoryIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      categoryIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> dateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      dateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> dateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> dateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> dateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> dateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> isPaidEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPaid',
        value: value,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> tagsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tags',
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      tagsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tags',
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> tagsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      tagsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> tagsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> tagsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      tagsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> tagsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> tagsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> tagsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tags',
        value: '',
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> valueEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      valueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> valueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> valueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension BankSlipIsarQueryObject
    on QueryBuilder<BankSlipIsar, BankSlipIsar, QFilterCondition> {}

extension BankSlipIsarQueryLinks
    on QueryBuilder<BankSlipIsar, BankSlipIsar, QFilterCondition> {
  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition> monthlyBudget(
      FilterQuery<MonthlyBudgetIsar> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'monthlyBudget');
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterFilterCondition>
      monthlyBudgetIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'monthlyBudget', 0, true, 0, true);
    });
  }
}

extension BankSlipIsarQuerySortBy
    on QueryBuilder<BankSlipIsar, BankSlipIsar, QSortBy> {
  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy>
      sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> sortByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> sortByIsPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.desc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> sortByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tags', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> sortByTagsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tags', Sort.desc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension BankSlipIsarQuerySortThenBy
    on QueryBuilder<BankSlipIsar, BankSlipIsar, QSortThenBy> {
  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy>
      thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> thenByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> thenByIsPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.desc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> thenByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tags', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> thenByTagsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tags', Sort.desc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension BankSlipIsarQueryWhereDistinct
    on QueryBuilder<BankSlipIsar, BankSlipIsar, QDistinct> {
  QueryBuilder<BankSlipIsar, BankSlipIsar, QDistinct> distinctByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId');
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QDistinct> distinctByDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QDistinct> distinctByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPaid');
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QDistinct> distinctByTags(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BankSlipIsar, BankSlipIsar, QDistinct> distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value');
    });
  }
}

extension BankSlipIsarQueryProperty
    on QueryBuilder<BankSlipIsar, BankSlipIsar, QQueryProperty> {
  QueryBuilder<BankSlipIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BankSlipIsar, int?, QQueryOperations> categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<BankSlipIsar, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<BankSlipIsar, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<BankSlipIsar, bool, QQueryOperations> isPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPaid');
    });
  }

  QueryBuilder<BankSlipIsar, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<BankSlipIsar, String?, QQueryOperations> tagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tags');
    });
  }

  QueryBuilder<BankSlipIsar, double, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCategoryIsarCollection on Isar {
  IsarCollection<CategoryIsar> get categoryIsars => this.collection();
}

const CategoryIsarSchema = CollectionSchema(
  name: r'CategoryIsar',
  id: -4389972771325497694,
  properties: {
    r'budgetLimit': PropertySchema(
      id: 0,
      name: r'budgetLimit',
      type: IsarType.double,
    ),
    r'colorValue': PropertySchema(
      id: 1,
      name: r'colorValue',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'iconCodePoint': PropertySchema(
      id: 4,
      name: r'iconCodePoint',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 5,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _categoryIsarEstimateSize,
  serialize: _categoryIsarSerialize,
  deserialize: _categoryIsarDeserialize,
  deserializeProp: _categoryIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _categoryIsarGetId,
  getLinks: _categoryIsarGetLinks,
  attach: _categoryIsarAttach,
  version: '3.3.0',
);

int _categoryIsarEstimateSize(
  CategoryIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _categoryIsarSerialize(
  CategoryIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.budgetLimit);
  writer.writeLong(offsets[1], object.colorValue);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.description);
  writer.writeLong(offsets[4], object.iconCodePoint);
  writer.writeString(offsets[5], object.name);
}

CategoryIsar _categoryIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CategoryIsar();
  object.budgetLimit = reader.readDouble(offsets[0]);
  object.colorValue = reader.readLong(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.description = reader.readString(offsets[3]);
  object.iconCodePoint = reader.readLong(offsets[4]);
  object.id = id;
  object.name = reader.readString(offsets[5]);
  return object;
}

P _categoryIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _categoryIsarGetId(CategoryIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _categoryIsarGetLinks(CategoryIsar object) {
  return [];
}

void _categoryIsarAttach(
    IsarCollection<dynamic> col, Id id, CategoryIsar object) {
  object.id = id;
}

extension CategoryIsarQueryWhereSort
    on QueryBuilder<CategoryIsar, CategoryIsar, QWhere> {
  QueryBuilder<CategoryIsar, CategoryIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CategoryIsarQueryWhere
    on QueryBuilder<CategoryIsar, CategoryIsar, QWhereClause> {
  QueryBuilder<CategoryIsar, CategoryIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CategoryIsarQueryFilter
    on QueryBuilder<CategoryIsar, CategoryIsar, QFilterCondition> {
  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      budgetLimitEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'budgetLimit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      budgetLimitGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'budgetLimit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      budgetLimitLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'budgetLimit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      budgetLimitBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'budgetLimit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      colorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      colorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      colorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      colorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      iconCodePointEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconCodePoint',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      iconCodePointGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconCodePoint',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      iconCodePointLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconCodePoint',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      iconCodePointBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconCodePoint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension CategoryIsarQueryObject
    on QueryBuilder<CategoryIsar, CategoryIsar, QFilterCondition> {}

extension CategoryIsarQueryLinks
    on QueryBuilder<CategoryIsar, CategoryIsar, QFilterCondition> {}

extension CategoryIsarQuerySortBy
    on QueryBuilder<CategoryIsar, CategoryIsar, QSortBy> {
  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> sortByBudgetLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetLimit', Sort.asc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy>
      sortByBudgetLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetLimit', Sort.desc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> sortByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy>
      sortByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> sortByIconCodePoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.asc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy>
      sortByIconCodePointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.desc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension CategoryIsarQuerySortThenBy
    on QueryBuilder<CategoryIsar, CategoryIsar, QSortThenBy> {
  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> thenByBudgetLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetLimit', Sort.asc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy>
      thenByBudgetLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetLimit', Sort.desc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> thenByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy>
      thenByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> thenByIconCodePoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.asc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy>
      thenByIconCodePointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.desc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension CategoryIsarQueryWhereDistinct
    on QueryBuilder<CategoryIsar, CategoryIsar, QDistinct> {
  QueryBuilder<CategoryIsar, CategoryIsar, QDistinct> distinctByBudgetLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'budgetLimit');
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QDistinct> distinctByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorValue');
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QDistinct>
      distinctByIconCodePoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconCodePoint');
    });
  }

  QueryBuilder<CategoryIsar, CategoryIsar, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension CategoryIsarQueryProperty
    on QueryBuilder<CategoryIsar, CategoryIsar, QQueryProperty> {
  QueryBuilder<CategoryIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CategoryIsar, double, QQueryOperations> budgetLimitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'budgetLimit');
    });
  }

  QueryBuilder<CategoryIsar, int, QQueryOperations> colorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorValue');
    });
  }

  QueryBuilder<CategoryIsar, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CategoryIsar, String, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<CategoryIsar, int, QQueryOperations> iconCodePointProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconCodePoint');
    });
  }

  QueryBuilder<CategoryIsar, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingIsarCollection on Isar {
  IsarCollection<AppSettingIsar> get appSettingIsars => this.collection();
}

const AppSettingIsarSchema = CollectionSchema(
  name: r'AppSettingIsar',
  id: 3217146887774323522,
  properties: {
    r'key': PropertySchema(
      id: 0,
      name: r'key',
      type: IsarType.string,
    ),
    r'value': PropertySchema(
      id: 1,
      name: r'value',
      type: IsarType.string,
    )
  },
  estimateSize: _appSettingIsarEstimateSize,
  serialize: _appSettingIsarSerialize,
  deserialize: _appSettingIsarDeserialize,
  deserializeProp: _appSettingIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appSettingIsarGetId,
  getLinks: _appSettingIsarGetLinks,
  attach: _appSettingIsarAttach,
  version: '3.3.0',
);

int _appSettingIsarEstimateSize(
  AppSettingIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  {
    final value = object.value;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _appSettingIsarSerialize(
  AppSettingIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.key);
  writer.writeString(offsets[1], object.value);
}

AppSettingIsar _appSettingIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSettingIsar();
  object.id = id;
  object.key = reader.readString(offsets[0]);
  object.value = reader.readStringOrNull(offsets[1]);
  return object;
}

P _appSettingIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appSettingIsarGetId(AppSettingIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSettingIsarGetLinks(AppSettingIsar object) {
  return [];
}

void _appSettingIsarAttach(
    IsarCollection<dynamic> col, Id id, AppSettingIsar object) {
  object.id = id;
}

extension AppSettingIsarQueryWhereSort
    on QueryBuilder<AppSettingIsar, AppSettingIsar, QWhere> {
  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingIsarQueryWhere
    on QueryBuilder<AppSettingIsar, AppSettingIsar, QWhereClause> {
  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppSettingIsarQueryFilter
    on QueryBuilder<AppSettingIsar, AppSettingIsar, QFilterCondition> {
  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      valueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      valueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'value',
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      valueEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      valueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      valueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      valueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      valueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'value',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      valueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'value',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      valueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterFilterCondition>
      valueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'value',
        value: '',
      ));
    });
  }
}

extension AppSettingIsarQueryObject
    on QueryBuilder<AppSettingIsar, AppSettingIsar, QFilterCondition> {}

extension AppSettingIsarQueryLinks
    on QueryBuilder<AppSettingIsar, AppSettingIsar, QFilterCondition> {}

extension AppSettingIsarQuerySortBy
    on QueryBuilder<AppSettingIsar, AppSettingIsar, QSortBy> {
  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterSortBy> sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterSortBy> sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension AppSettingIsarQuerySortThenBy
    on QueryBuilder<AppSettingIsar, AppSettingIsar, QSortThenBy> {
  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterSortBy> thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QAfterSortBy> thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension AppSettingIsarQueryWhereDistinct
    on QueryBuilder<AppSettingIsar, AppSettingIsar, QDistinct> {
  QueryBuilder<AppSettingIsar, AppSettingIsar, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettingIsar, AppSettingIsar, QDistinct> distinctByValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value', caseSensitive: caseSensitive);
    });
  }
}

extension AppSettingIsarQueryProperty
    on QueryBuilder<AppSettingIsar, AppSettingIsar, QQueryProperty> {
  QueryBuilder<AppSettingIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSettingIsar, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<AppSettingIsar, String?, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}
