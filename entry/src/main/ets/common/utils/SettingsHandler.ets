import { HashMap, JSON} from '@kit.ArkTS'
import { fileIo as fs , WriteOptions} from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';
import { common, contextConstant } from '@kit.AbilityKit';
import json from '@ohos.util.json';
import { BusinessError } from '@kit.BasicServicesKit';
import {SettingsModel} from '../../model/SettingsModel'


export default class SettingsHandler{
        private context = getContext(this) as common.UIAbilityContext;
        private preferenceDir: string;
        private filePath: string;
        private arrayBuffer: ArrayBuffer
        private template: SettingsModel;


        constructor(){
                this.context.area = contextConstant.AreaMode.EL1
                this.preferenceDir = this.context.getApplicationContext().preferencesDir;
                this.filePath = this.preferenceDir + "/preference.json"
                this.arrayBuffer = new ArrayBuffer(4096);

                this.template = {
                        background: "app.media.background1",
                        remindTime: 0,
                        format: 0
                }
        }

        async initPreference(fd: number){

                let jsonFormatTemplate = JSON.stringify(this.template)
                fs.write(fd, jsonFormatTemplate).then((writeLen: number) => {
                        console.info("write data to file succeed and size is:" + writeLen);
                }).catch((err: BusinessError) => {
                        console.error("write data to file failed with error message: " + err.message + ", error code: " + err.code);
                })
        }




        async getPreference(): Promise<SettingsModel> {
                return new Promise((resolve, reject) => {
                        fs.open(this.filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
                                .then((file: fs.File) => {
                                        console.info("file fd: " + file.fd);
                                        fs.read(file.fd, this.arrayBuffer)
                                                .then((readLen: number) => {
                                                        console.info("read file data succeed");
                                                        let buf = buffer.from(this.arrayBuffer, 0, readLen);
                                                        if (buf.length === 0) {
                                                                console.info("empty file");
                                                                this.initPreference(file.fd);
                                                                resolve(this.template);  // Assuming this.template is of type SettingsModel
                                                        } else {
                                                                let data = buf.toString();
                                                                console.info(`The content of file: ${data}`);
                                                                try {
                                                                        let jsonSettings = JSON.parse(buf.toString()) as SettingsModel
                                                                        resolve(jsonSettings);
                                                                } catch (error) {
                                                                        reject(new Error("Error parsing JSON: " + error.message));
                                                                }
                                                        }
                                                })
                                                .catch((err: BusinessError) => {
                                                        console.error("read file data failed with error message: " + err.message + ", error code: " + err.code);
                                                        reject(err);
                                                })
                                                .finally(() => {
                                                        fs.closeSync(file);
                                                });
                                })
                                .catch((err: BusinessError) => {
                                        console.error("open file failed with error message: " + err.message + ", error code: " + err.code);
                                        reject(err);
                                });
                });
        }

        async changeSettings(name: string, value: string){
                console.info("Log     "  +  value)
                fs.open(this.filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).then((file: fs.File) => {
                        console.info("file fd: " + file.fd);
                        fs.read(file.fd, this.arrayBuffer).then((readLen: number) => {
                                console.info("read file data succeed");
                                let buf = buffer.from(this.arrayBuffer, 0, readLen);

                                if(buf.length !== 0){

                                        let jsonSettings = JSON.parse(buf.toString()) as SettingsModel
                                        if(jsonSettings !== null){
                                                switch(name){
                                                        case "background":
                                                                jsonSettings.background = value
                                                                break;
                                                        case "format":
                                                                jsonSettings.format = Number(value)
                                                                break;
                                                        case "remindTime":
                                                                jsonSettings.remindTime = Number(value)
                                                                break;
                                                }
                                                let writeOption: WriteOptions = {
                                                        offset: 0
                                                }


                                                fs.write(file.fd, JSON.stringify(jsonSettings), writeOption).then((writeLen: number) => {
                                                        console.info("write data to file succeed and size is:" + writeLen + "    Data is:" + JSON.stringify(jsonSettings));
                                                }).catch((err: BusinessError) => {
                                                        console.error("write data to file failed with error message: " + err.message + ", error code: " + err.code);
                                                }).then(() => {
                                                        fs.closeSync(file);
                                                })
                                                console.info("Log     "  +  JSON.stringify(jsonSettings))
                                        }

                                }

                        }).catch((err: BusinessError) => {
                                console.error("read file data failed with error message: " + err.message + ", error code: " + err.code);
                        }).finally(() => {

                        });
                }).catch((err: BusinessError) => {
                        console.error("open file failed with error message: " + err.message + ", error code: " + err.code);
                });
        }

        getSettingsFormat(date: Date, option: number): string{
                let result: string = ""
                switch (option) {
                        case 0:
                                result = ((date as Date).getFullYear() + "年-"
                                        + ((date as Date).getMonth() + 1)
                                        + "月-" + (date as Date).getDate()+"日")
                                break;

                        case 1:
                                result = (((date as Date).getMonth() + 1)
                                        + "月-" + (date as Date).getDate()+"日-" + (date as Date).getFullYear() + "年")
                                break;

                        case 2:
                                result = ((date as Date).getDate()+"日-" + ((date as Date).getMonth() + 1)
                                        + "月-"  + (date as Date).getFullYear() + "年")
                                break;
                        default:
                                break;
                }


                return result;
        }





}