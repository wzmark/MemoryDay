/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include "RDB.h"

void RDB::Rdb_init(std::string databaseDir, std::string bundleName) {
    config.dataBaseDir = databaseDir.c_str();
    config.storeName = "RdbTest.db";
    config.bundleName = bundleName.c_str();
    config.moduleName = "entry";
    config.securityLevel = OH_Rdb_SecurityLevel::S1;
    config.isEncrypt = false;
    config.selfSize = sizeof(OH_Rdb_Config);
    config.area = RDB_SECURITY_AREA_EL1;

    int errCode = 0;
    store_ = OH_Rdb_GetOrOpen(&config, &errCode);
}


void RDB::Rdb_add(std::string title, std::string date, std::string repeat, std::string tag, std::string top, std::string reminderId) {
        /*TODO: 删除重新设置数据库操作
        */
        /*
        char dropTableSql[] = "DROP TABLE IF EXISTS EVENTS";
        OH_Rdb_Execute(store_, dropTableSql);
        */
        char createTableSql[] =
        "CREATE TABLE IF NOT EXISTS EVENTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT NOT NULL, DATE TEXT NOT NULL, REPEAT TEXT NOT NULL, TAG TEXT NOT NULL, TOP TEXT NOT NULL, REMINDERID TEXT NOT NULL)";
        OH_Rdb_Execute(store_, createTableSql);

        OH_VBucket *valueBucket = OH_Rdb_CreateValuesBucket();
        valueBucket->putText(valueBucket, "TITLE", title.c_str());
        valueBucket->putText(valueBucket, "DATE", date.c_str());
        valueBucket->putText(valueBucket, "REPEAT", repeat.c_str());
        valueBucket->putText(valueBucket, "TAG", tag.c_str());
        valueBucket->putText(valueBucket, "TOP", top.c_str());
        valueBucket->putText(valueBucket, "REMINDERID", reminderId.c_str());

        int rowId = OH_Rdb_Insert(store_, "EVENTS", valueBucket);

        valueBucket->destroy(valueBucket);
}
void RDB::Rdb_change(int64_t id, std::string changedTitle, std::string changedDate, std::string changedRepeat, std::string changedTag, std::string changedTop, std::string reminderId) {
        OH_VBucket *valueBucket = OH_Rdb_CreateValuesBucket();
        valueBucket->putText(valueBucket, "TITLE", changedTitle.c_str());
        valueBucket->putText(valueBucket, "DATE", changedDate.c_str());
        valueBucket->putText(valueBucket, "REPEAT", changedRepeat.c_str());
        valueBucket->putText(valueBucket, "TAG", changedTag.c_str());
        valueBucket->putText(valueBucket, "TOP", changedTop.c_str());
        valueBucket->putText(valueBucket, "REMINDERID", reminderId.c_str());
        OH_Predicates *predicates = OH_Rdb_CreatePredicates("EVENTS");
        OH_VObject *valueObject = OH_Rdb_CreateValueObject();

        valueObject->putInt64(valueObject, &id, 1);
        predicates->equalTo(predicates, "ID", valueObject);

        int changeRows = OH_Rdb_Update(store_, valueBucket, predicates);
        valueObject->destroy(valueObject);
        valueBucket->destroy(valueBucket);
        predicates->destroy(predicates);
}
std::vector<Event> RDB::Rdb_search(void) {
        
        std::vector<Event> searchResult;
        
        OH_Predicates *predicates = OH_Rdb_CreatePredicates("EVENTS");
        const char *columnNames[] = {"ID", "TITLE", "DATE", "REPEAT", "TAG", "TOP"};
        int len = sizeof(columnNames) / sizeof(columnNames[0]);
        OH_Cursor *cursor = OH_Rdb_Query(store_, predicates, columnNames, len);
        
        int columnCount = 0;
        cursor->getColumnCount(cursor, &columnCount);
                        
                
        int64_t id;
        char title[30] = "";
        char date[30] = "";
        char repeat[30] = "";
        char tag[30] = "";
        char top[30] = "";
                
           
    while (cursor->goToNextRow(cursor) == OH_Rdb_ErrCode::RDB_OK) {
                cursor->getInt64(cursor, 0, &id);
                cursor->getText(cursor, 1, title, 30);
                cursor->getText(cursor, 2, date, 30);
                cursor->getText(cursor, 3, repeat, 30);
                cursor->getText(cursor, 4, tag, 30);
                cursor->getText(cursor, 5, top, 30);
                
                
                searchResult.push_back({id, title, date, repeat, tag, top});
    }

    predicates->destroy(predicates);
    cursor->destroy(cursor);
    return searchResult;
}
void RDB::Rdb_delete(int64_t id) {
    OH_Predicates *predicates = OH_Rdb_CreatePredicates("EVENTS");
    OH_VObject *valueObject = OH_Rdb_CreateValueObject();

    valueObject->putInt64(valueObject, &id, 1);
    predicates->equalTo(predicates, "ID", valueObject);

    int deleteRows = OH_Rdb_Delete(store_, predicates);

    valueObject->destroy(valueObject);
    predicates->destroy(predicates);
}

void RDB::Rdb_deleteRdb(void) {
    OH_Rdb_CloseStore(store_);
    OH_Rdb_DeleteStore(&config);
}