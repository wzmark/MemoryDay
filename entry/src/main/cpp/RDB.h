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
#ifndef DATABASE_READ_WRITE_RDB_H
#define DATABASE_READ_WRITE_RDB_H
#include "napi/native_api.h"
#include <database/data/data_asset.h>
#include <database/rdb/oh_cursor.h>
#include <database/rdb/oh_predicates.h>
#include <database/rdb/oh_values_bucket.h>
#include <database/rdb/oh_value_object.h>
#include <database/rdb/relational_store_error_code.h>
#include <database/rdb/relational_store.h>
#include <bundle/native_interface_bundle.h>
#include <cstdlib>
#include <string>
#include <vector>
#include "hilog/log.h"

struct Event {
        int64_t id;
        std::string title;
        std::string date;
        std::string repeat;
        std::string tag;
        std::string top;
        
};

class RDB {
public:
    OH_Rdb_Store *store_;
    OH_Rdb_Config config;

    void Rdb_init(std::string databaseDir, std::string bundleName);
    void Rdb_add(std::string title, std::string date, std::string repeat, std::string tag, std::string top, std::string reminderId);
    void Rdb_change(int64_t id, std::string changedTitle, std::string changedDate, std::string changedRepeat, std::string changedTag, std::string changedTop, std::string reminderId);
    std::vector<Event> Rdb_search(void);
    void Rdb_delete(int64_t id);
    void Rdb_deleteRdb(void);
};

#endif // DATABASE_READ_WRITE_RDB_H
