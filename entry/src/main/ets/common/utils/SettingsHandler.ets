import { HashMap, JSON} from '@kit.ArkTS'
import { fileIo as fs } from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';
import { common, contextConstant } from '@kit.AbilityKit';
import json from '@ohos.util.json';
import { BusinessError } from '@kit.BasicServicesKit';
import {SettingsModel} from '../../model/SettingsModel'


export default class Settings{
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




        async getPreference(): Promise<SettingsModel>{
                let data: string = "";

                fs.open(this.filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).then((file: fs.File) => {
                        console.info("file fd: " + file.fd);
                        fs.read(file.fd, this.arrayBuffer).then((readLen: number) => {
                                console.info("read file data succeed");
                                let buf = buffer.from(this.arrayBuffer, 0, readLen);
                                if(buf.length === 0){
                                        console.info("empty file")
                                        this.initPreference(file.fd)

                                }else{
                                        data = buf.toString()
                                        console.info(`The content of file: ${buf.toString()}`);
                                }

                        }).catch((err: BusinessError) => {
                                console.error("read file data failed with error message: " + err.message + ", error code: " + err.code);
                        }).finally(() => {
                                fs.closeSync(file);
                        });
                }).catch((err: BusinessError) => {
                        console.error("open file failed with error message: " + err.message + ", error code: " + err.code);
                });
                if(data.length === 0){
                        let result: SettingsModel = {
                                background: "app.media.background1",
                                remindTime: 0,
                                format: 0
                        }
                        let jsonResult = JSON.stringify(data)
                        result.background = jsonResult["background"]
                        result.format = jsonResult["format"]
                        result.remindTime = jsonResult["remindTime"]

                }
                return this.template
        }

        async changeSettings(name: string, value: string){
                fs.open(this.filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE).then((file: fs.File) => {
                        console.info("file fd: " + file.fd);
                        fs.read(file.fd, this.arrayBuffer).then((readLen: number) => {
                                console.info("read file data succeed");
                                let buf = buffer.from(this.arrayBuffer, 0, readLen);
                                if(buf.length !== 0){
                                        let jsonSettings = JSON.stringify(buf.toString())
                                        jsonSettings[name] = value
                                        fs.write(file.fd, jsonSettings).then((writeLen: number) => {
                                                console.info("write data to file succeed and size is:" + writeLen);
                                        }).catch((err: BusinessError) => {
                                                console.error("write data to file failed with error message: " + err.message + ", error code: " + err.code);
                                        })
                                }

                        }).catch((err: BusinessError) => {
                                console.error("read file data failed with error message: " + err.message + ", error code: " + err.code);
                        }).finally(() => {
                                fs.closeSync(file);
                        });
                }).catch((err: BusinessError) => {
                        console.error("open file failed with error message: " + err.message + ", error code: " + err.code);
                });
        }





}