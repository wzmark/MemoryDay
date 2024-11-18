import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import {AddEventButton} from '../components/AddEventButton'
import { CustomizedDatePicker } from '../components/CustomizedDatePicker';
import { InputBox } from '../components/InputBox';
import { SettingsButton } from '../components/SettingsButton';

import { common, contextConstant } from '@kit.AbilityKit';
import { distributedKVStore } from '@kit.ArkData';

import KVStore from '../common/utils/KVStore';
import { KVStoreType } from '../viewmodel/KVStoreType';
import { EventList, EventItem } from '../model/EventModel';
import { EventDisplayList } from '../components/EventDisplayList';
import { DayArrowSymbol } from '../components/DayArrowSymbol';
import { TopEventDisplay } from '../components/TopEventDisplay';
import SettingsHandler from '../common/utils/SettingsHandler';
import { SettingsModel } from '../model/SettingsModel';


@Entry
@Component
struct Index {



        @State securityLevel: distributedKVStore.SecurityLevel = distributedKVStore.SecurityLevel.S1;
        @StorageLink('encrypted') encrypted: boolean = false;
        @StorageLink('kvStore') kvStore: KVStore | undefined = new KVStore(this.encrypted, this.securityLevel);
        @StorageLink('kvStoreAll') kvStoreAll: KVStoreType[] = [];

        private context = getContext(this) as common.UIAbilityContext;
        private settings = new SettingsHandler();
        @State settingsModel: SettingsModel = {
                background: "app.media.background4",
                remindTime: 0,
                format: 0
        };

        @State eventList: EventItem[] = [];
        @State topEvent: KVStoreType = new KVStoreType("", "", "");
        @State tempBackground: string = "app.media.background2"
        @State needsRender: boolean = false
        @State customizedBackground: PixelMap | ResourceStr | undefined = undefined

        aboutToAppear(): void {

                this.context.area = contextConstant.AreaMode.EL2
                let databaseDir = this.context.getApplicationContext().databaseDir;

                testNapi.initRDB(databaseDir);
                this.handleDataExtract()

                this.handlePreferencesExtract()




        }

        private async handlePreferencesExtract(){

                this.settingsModel =  await this.settings.getPreference()

                this.customizedBackground = await this.settings.getCustomizedPhoto()
                this.tempBackground = this.settingsModel.background
                this.needsRender = true
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
                if(this.needsRender){
                        Column() {
                                Column(){
                                        Row() {
                                                SettingsButton()

                                                Text("      纪念日")
                                                        .fontSize(24)
                                                        .fontWeight(FontWeight.Bold)
                                                        .fontColor("#ffffff").width("40%")
                                                AddEventButton()

                                        }.justifyContent(FlexAlign.SpaceBetween).width("95%").margin({
                                                top: '30px',    // 设置上外边距
                                                bottom: '30px', // 设置下外边距
                                        })
                                        if(this.eventList.length > 0){
                                                TopEventDisplay({event: this.eventList[0]})
                                        }
                                        //
                                }



                                Column(){
                                        EventDisplayList({eventList: this.eventList}).height("60%")
                                }.width("100%").backgroundColor('rgba(103, 102, 102, 0.5)')



                        }.width('100%').justifyContent(FlexAlign.SpaceBetween).height("100%").backgroundImage(this.customizedBackground).backgroundImageSize(ImageSize.Cover)
                }



        }
}
