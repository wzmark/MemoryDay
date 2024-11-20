import { HashMap, JSON} from '@kit.ArkTS'
import { fileIo as fs , WriteOptions} from '@kit.CoreFileKit';
import { buffer } from '@kit.ArkTS';
import { common, contextConstant } from '@kit.AbilityKit';
import json from '@ohos.util.json';
import { BusinessError } from '@kit.BasicServicesKit';
import {SettingsModel} from '../../model/SettingsModel'
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { image } from '@kit.ImageKit';
import { resourceManager } from '@kit.LocalizationKit';


interface GeneratedObjectLiteralInterface_1 {
        "rotate": number;
}

export default class SettingsHandler{
        private context = getContext(this) as common.UIAbilityContext;
        private preferenceDir: string;
        private filePath: string;
        private arrayBuffer: ArrayBuffer
        private template: SettingsModel;
        private customizedImagePath: string


        constructor(){
                this.context.area = contextConstant.AreaMode.EL1
                this.preferenceDir = this.context.getApplicationContext().preferencesDir;
                this.filePath = this.preferenceDir + "/preference.json"
                this.customizedImagePath = this.preferenceDir + "/customizedImage.jpg"
                this.arrayBuffer = new ArrayBuffer(10240);

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
                                                console.info("Change settings:  "  + JSON.stringify(jsonSettings))
                                                fs.truncate(file.fd, 0)
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


        async handlePhotoSelect(): Promise<image.PixelMap>{
                return new Promise((resolve, reject) => {
                        try {
                                let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
                                PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
                                PhotoSelectOptions.maxSelectNumber = 1;
                                let photoPicker = new photoAccessHelper.PhotoViewPicker();
                                photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult: photoAccessHelper.PhotoSelectResult) => {
                                        console.info('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
                                        let tempImagePath = PhotoSelectResult.photoUris[0]
                                        fs.open(tempImagePath, fs.OpenMode.READ_ONLY).then((file: fs.File) => {
                                                fs.copyFile(file.fd, this.customizedImagePath, 0, (err: BusinessError) => {
                                                        if (err) {
                                                                console.error("copy file failed with error message: " + err.message + ", error code: " + err.code);
                                                        } else {
                                                                let imageSource = image.createImageSource(file.fd)
                                                                imageSource.createPixelMap((err, pixelmap) => {
                                                                        resolve(pixelmap)
                                                                })
                                                                console.info("copy file succeed");
                                                        }
                                                })
                                        }).catch((err: BusinessError) => {
                                                console.error("read file data failed with error message: " + err.message + ", error code: " + err.code);
                                        })
                                }).catch((err: BusinessError) => {
                                        console.error(`PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
                                });
                        } catch (error) {
                                let err: BusinessError = error as BusinessError;
                                console.error(`PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
                        }
                })

        }

        async getCustomizedPhoto(): Promise<image.PixelMap>{

                let settings: SettingsModel = await this.getPreference()

                const background = settings.background

                return new Promise((resolve, reject) => {
                        if(background === "customizedImage"){

                                fs.open(this.customizedImagePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
                                        .then((file: fs.File) => {
                                                console.info("file fd: " + file.fd);
                                                let imageSource = image.createImageSource(file.fd)
                                                imageSource.createPixelMap((err, pixelmap) => {
                                                        resolve(pixelmap)
                                                })
                                        })
                                        .catch((err: BusinessError) => {
                                                console.error("open file failed with error message: " + err.message + ", error code: " + err.code);
                                                reject(err);
                                        });
                        }else{
                                let fileId = -1
                                console.info("Log123  " + background + "   id   " + $r(background).id + "    normal id  " + $r("app.media.background2").id)
                                switch (background){
                                        case "app.media.background1":
                                                fileId = $r("app.media.background1").id
                                                break
                                        case "app.media.background2":
                                                fileId = $r("app.media.background2").id
                                                break
                                        case "app.media.background3":
                                                fileId = $r("app.media.background3").id
                                                break
                                        case "app.media.background4":
                                                fileId = $r("app.media.background4").id
                                                break
                                }
                                this.context.resourceManager.getMediaContent(fileId).then((data) => {

                                        this.arrayBuffer = data.buffer.slice(data.byteOffset, data.byteLength + data.byteOffset)
                                        let imageSource: image.ImageSource = image.createImageSource(this.arrayBuffer);
                                        imageSource.getImageInfo((err, value) => {
                                                //获取图片资源的尺寸
                                                console.log(`图片的尺寸为：width:${value.size.width}height:${value.size.height}`)
                                                if (err) {return;}
                                                //转PixelMap
                                                let opts: image.DecodingOptions =
                                                        { editable: true, desiredSize: { height: value.size.height, width: value.size.width } };
                                                imageSource.createPixelMap(opts, (err,
                                                        pixelMap) => {
                                                        let imagePixelMap = pixelMap
                                                        resolve(imagePixelMap)
                                                })
                                        })
                                }).catch((err: BusinessError) => {
                                        console.error("open Image with error: " + err.message + ", error code: " + err.code);
                                        reject(err);
                                })
                        }









                });
        }





}