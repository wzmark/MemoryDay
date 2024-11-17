import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import {AddEventButton} from '../components/AddEventButton'
import { CustomizedDatePicker } from '../components/CustomizedDatePicker';
import { InputBox } from '../components/InputBox';
import { SettingsButton } from '../components/SettingsButton';
import {CustomizedPicker} from '../components/CustomizedPicker'
import { OptionsPicker } from '../components/OptionsPicker';
import { CheckButton } from '../components/CheckButton';
import { ReturnButton } from '../components/ReturnButton';
import { preferences } from '@kit.ArkData';
import { common, contextConstant } from '@kit.AbilityKit';
import { distributedKVStore } from '@kit.ArkData';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import KVStore from '../common/utils/KVStore';
import { KVStoreType } from '../viewmodel/KVStoreType';
import { EventList, EventItem } from '../model/EventModel';
import { EventDisplayList } from '../components/EventDisplayList';
import { DayArrowSymbol } from '../components/DayArrowSymbol';
import { TopEventDisplay } from '../components/TopEventDisplay';
import data from '../../resources/base/element/string.json'
import { fileIo as fs } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';





@Entry
@Component
struct Index {



        @State securityLevel: distributedKVStore.SecurityLevel = distributedKVStore.SecurityLevel.S1;
        @StorageLink('encrypted') encrypted: boolean = false;
        @StorageLink('kvStore') kvStore: KVStore | undefined = new KVStore(this.encrypted, this.securityLevel);
        @StorageLink('kvStoreAll') kvStoreAll: KVStoreType[] = [];

        private context = getContext(this) as common.UIAbilityContext;


        @State eventList: EventItem[] = [];
        @State topEvent: KVStoreType = new KVStoreType("", "", "");


        aboutToAppear(): void {
                this.context.area = contextConstant.AreaMode.EL2
                let databaseDir = this.context.getApplicationContext().databaseDir;

                testNapi.initRDB(databaseDir);
                this.handleDataExtract()
                this.handlePreferencesExtract()


        }

        private async handlePreferencesExtract(){
                //切换低加密加密级别
                this.context.area = contextConstant.AreaMode.EL1
                let preferenceDir = this.context.getApplicationContext().preferencesDir;
                console.info("Test   " +preferenceDir)
                let pathDir = preferenceDir + "preference.json"
                let arrayBuffer = new ArrayBuffer(4096);
                fs.open(pathDir, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).then((file: fs.File) => {
                        console.info("file fd: " + file.fd);
                        fs.read(file.fd, arrayBuffer).then((readLen: number) => {
                                console.info("read file data succeed");
                                let buf = buffer.from(arrayBuffer, 0, readLen);
                                if(buf.length === 0){
                                        console.info("empty file")
                                }
                                console.info(`The content of file: ${buf.toString()}`);
                        }).catch((err: BusinessError) => {
                                console.error("read file data failed with error message: " + err.message + ", error code: " + err.code);
                        }).finally(() => {
                                fs.closeSync(file);
                        });
                }).catch((err: BusinessError) => {
                        console.error("open file failed with error message: " + err.message + ", error code: " + err.code);
                });

        }



        private async handleDataExtract(){










                let resultObjects = testNapi.searchRDB() as object[];
                for (let i: number = 0; i < resultObjects.length; i++) {
                        let newEvent = new EventItem(resultObjects[i]['title'], resultObjects[i]['date'], resultObjects[i]['repeat'], resultObjects[i]['tag'],  resultObjects[i]['top']);
                        this.eventList.push(newEvent);
                        console.error(resultObjects[i]['title'] + " |  " + resultObjects[i]['date'] +"  |  " + resultObjects[i]['tag'] + "  |  " + resultObjects[i]['repeat'] + "  | " + resultObjects[i]['top'])

                }
                let index: number = 0
                for(let i : number = 0; i < this.eventList.length; i++){
                        if(this.eventList[i].top){
                                let tempEvent : EventItem = this.eventList[i]
                                this.eventList[i] = this.eventList[index]
                                this.eventList[index] = tempEvent
                                index++
                        }
                }




        }


        build() {

                        Column() {
                                Column(){
                                        Row() {
                                                SettingsButton()

                                                Text("      纪念日")
                                                        .fontSize(24)
                                                        .fontWeight(FontWeight.Bold)
                                                        .fontColor("#ffffff").width("40%")
                                                AddEventButton()

                                        }.justifyContent(FlexAlign.SpaceBetween).width("95%")

                                        TopEventDisplay({event: this.eventList[0]})
                                }



                                Column(){
                                        EventDisplayList({eventList: this.eventList}).height("60%")
                                }.width("100%").backgroundColor('rgba(103, 102, 102, 0.5)')



                        }.width('100%').justifyContent(FlexAlign.SpaceBetween).height("100%").backgroundImage($r("app.media.background1")).backgroundImageSize(ImageSize.Cover)


        }
}
