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
#include "napi/native_api.h"
#include "hilog/log.h"
#include "RDB.h"
#include <bundle/native_interface_bundle.h>
#include <database/data/data_asset.h>
#include <database/rdb/oh_cursor.h>
#include <database/rdb/oh_predicates.h>
#include <database/rdb/oh_value_object.h>
#include <database/rdb/oh_values_bucket.h>
#include <database/rdb/relational_store.h>
#include <database/rdb/relational_store_error_code.h>

// #define LOG_TAG "DB_TAG"
RDB rdb;

static napi_value CreateArray(napi_env env, napi_callback_info info, std::vector<Event> &goods);
static napi_value NewObject(napi_env env, napi_callback_info info, int64_t _id, const char *_title, const char *_date, const char *_repeat,const char *_tag, const char *_top);


static napi_value InitRDB(napi_env env, napi_callback_info info) {
        size_t argc = 1;
        napi_value args[1] = {nullptr};
        napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
        size_t len = 0;
        char databaseDir[1024];
        napi_get_value_string_utf8(env, args[0], databaseDir, 100, &len);
        
        OH_NativeBundle_ApplicationInfo nativeApplicationInfo = OH_NativeBundle_GetCurrentApplicationInfo();
        napi_value bundleName;
        napi_create_string_utf8(env, nativeApplicationInfo.bundleName, NAPI_AUTO_LENGTH, &bundleName);
        char bundleNameArr[1024];
        napi_get_value_string_utf8(env, bundleName, bundleNameArr, 100, &len);
    // free(nativeApplicationInfo.bundleName);

        rdb.Rdb_init(databaseDir, bundleNameArr);
        return nullptr;
}

static napi_value AddRDB(napi_env env, napi_callback_info info) {
        // get parameters
        size_t argc = 6;
        napi_value args[6] = {nullptr};
        napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
        
        char title[31];
        napi_get_value_string_utf8(env, args[0], title, 30, nullptr);
        char date[31];
        napi_get_value_string_utf8(env, args[1], date, 30, nullptr);
        char tag[31];
        napi_get_value_string_utf8(env, args[2], tag, 30, nullptr);
        char repeat[31];
        napi_get_value_string_utf8(env, args[3], repeat, 30, nullptr);
        char top[31];
        napi_get_value_string_utf8(env, args[4], top, 30, nullptr);
        char reminderId[31];
        napi_get_value_string_utf8(env, args[5], reminderId, 30, nullptr);

        // execute RDB
        rdb.Rdb_add(title, date, repeat, tag, top, reminderId);
        return nullptr;
}

static napi_value SearchRDB(napi_env env, napi_callback_info info) {
        std::vector<Event> searchResult = rdb.Rdb_search();
        napi_value searchArray = CreateArray(env, info, searchResult);
        return searchArray;
}

static napi_value ChangeRDB(napi_env env, napi_callback_info info) {
        // get parameters
        size_t argc = 7;
        napi_value args[7] = {nullptr};
        napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

        int64_t eventId = 0;
        napi_get_value_int64(env, args[0], &eventId);

        char title[31];
        napi_get_value_string_utf8(env, args[1], title, 30, nullptr);
        char date[31];
        napi_get_value_string_utf8(env, args[2], date, 30, nullptr);
        char tag[31];
        napi_get_value_string_utf8(env, args[3], tag, 30, nullptr);
        char repeat[31];
        napi_get_value_string_utf8(env, args[4], repeat, 30, nullptr);
        char top[31];
        napi_get_value_string_utf8(env, args[5], top, 30, nullptr);
        char reminderId[31];
        napi_get_value_string_utf8(env, args[6], reminderId, 30, nullptr);

        // execute RDB
        rdb.Rdb_change(eventId, title, date, repeat, tag, top, reminderId);
        return nullptr;
}

static napi_value DeleteRDB(napi_env env, napi_callback_info info) {
        // get parameters
        size_t argc = 1;
        napi_value args[1] = {nullptr};
        napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
        int64_t eventId = 0;
        napi_get_value_int64(env, args[0], &eventId);

        // execute RDB
        rdb.Rdb_delete(eventId);
        return nullptr;
}

static napi_value SearchRDBByPriceAndType(napi_env env, napi_callback_info info) {
    // get parameters
        size_t argc = 2;
        napi_value args[2] = {nullptr};
        napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);
        char type[31];
        napi_get_value_string_utf8(env, args[0], type, 30, nullptr);
        int64_t price = 0;
        napi_get_value_int64(env, args[1], &price);

    // find all products
        std::vector<Event> allResults = rdb.Rdb_search();

    // step1: filter type field
        std::vector<Event> filterByType;
        if (type != "") {
                for (int i = 0; i < allResults.size(); i++) {
                        if (std::string(allResults[i].title).find(std::string(type)) != std::string::npos) {
                                filterByType.push_back(allResults[i]);
                        }
                }
        }
        

    // step2: filter price field
        std::vector<Event> filterByTypeAndPrice;
        /*
    if (price == 0) {
        return CreateArray(env, info, filterByType);
    } else if (price > 0) {
        for (int i = 0; i < filterByType.size(); i++) {
            if (filterByType[i].price >= price) {
                filterByTypeAndPrice.push_back(filterByType[i]);
            }
        }
    } else if (price < 0) {
        for (int i = 0; i < filterByType.size(); i++) {
            if (filterByType[i].price <= abs(price)) {
                filterByTypeAndPrice.push_back(filterByType[i]);
            }
        }
    }
        */

        napi_value searchArray = CreateArray(env, info, filterByTypeAndPrice);
        return searchArray;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports) {
    /* Associate the externally provided interface with the written method, for example, associate add with the Add
     * method.
     */
        napi_property_descriptor desc[] = {
        {"initRDB", nullptr, InitRDB, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"addRDB", nullptr, AddRDB, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"searchRDB", nullptr, SearchRDB, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"changeRDB", nullptr, ChangeRDB, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"deleteRDB", nullptr, DeleteRDB, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"searchFiltered", nullptr, SearchRDBByPriceAndType, nullptr, nullptr, nullptr, napi_default, nullptr}};
    // napi_define_properties construct a return value that contains a list of methods that correspond.
        napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
        return exports;
}
EXTERN_C_END

// Configure the module description and set the Init method to the napi_module entry method.
static napi_module demoModule = {.nm_version = 1,
                                 .nm_flags = 0,
                                 .nm_filename = nullptr,
                                 .nm_register_func = Init, // napi_module the entrance method.
                                 .nm_modname = "entry",    // napi_module module name.
                                 .nm_priv = ((void *)0),
                                 .reserved = {0}};

extern "C" __attribute__((constructor)) void RegisterConversionModule(void) { napi_module_register(&demoModule); }

// util
static napi_value CreateArray(napi_env env, napi_callback_info info, std::vector<Event> &events) {
    napi_value jsArray = nullptr;
    napi_create_array(env, &jsArray);
    int storeIndex = 0;
    for (int i = 0; i < events.size(); i++) {
                
                napi_value element = NewObject(env, info, events[i].id, 
                        events[i].title.c_str(), 
                        events[i].date.c_str(), 
                        events[i].repeat.c_str(), 
                        events[i].tag.c_str(),
                        events[i].top.c_str()
                
                );
        napi_set_element(env, jsArray, storeIndex++, element);
    }
    return jsArray;
}

static napi_value NewObject(napi_env env, napi_callback_info info, int64_t _id, const char *_title, const char *_date, const char *_repeat,const char *_tag, const char *_top) {
        napi_value object = nullptr;
        napi_create_object(env, &object);

        napi_value id = nullptr;
        napi_create_string_utf8(env, "id", NAPI_AUTO_LENGTH, &id);
        napi_value value1 = nullptr;
        napi_create_int64(env, _id, &value1);
        napi_set_property(env, object, id, value1);

        napi_value title = nullptr;
        napi_create_string_utf8(env, "title", NAPI_AUTO_LENGTH, &title);
        napi_value value2 = nullptr;
        napi_create_string_utf8(env, _title, NAPI_AUTO_LENGTH, &value2);
        napi_set_property(env, object, title, value2);
        
        napi_value date = nullptr;
        napi_create_string_utf8(env, "date", NAPI_AUTO_LENGTH, &date);
        napi_value value3 = nullptr;
        napi_create_string_utf8(env, _date, NAPI_AUTO_LENGTH, &value3);
        napi_set_property(env, object, date, value3);
        
        napi_value repeat = nullptr;
        napi_create_string_utf8(env, "repeat", NAPI_AUTO_LENGTH, &repeat);
        napi_value value4 = nullptr;
        napi_create_string_utf8(env, _repeat, NAPI_AUTO_LENGTH, &value4);
        napi_set_property(env, object, repeat, value4);
        
        napi_value tag = nullptr;
        napi_create_string_utf8(env, "tag", NAPI_AUTO_LENGTH, &tag);
        napi_value value5 = nullptr;
        napi_create_string_utf8(env, _tag, NAPI_AUTO_LENGTH, &value5);
        napi_set_property(env, object, tag, value5);
        
        napi_value top = nullptr;
        napi_create_string_utf8(env, "top", NAPI_AUTO_LENGTH, &top);
        napi_value value6 = nullptr;
        napi_create_string_utf8(env, _top, NAPI_AUTO_LENGTH, &value6);
        napi_set_property(env, object, top, value6);

    

        return object;
}
