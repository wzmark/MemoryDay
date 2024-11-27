import { BusinessError } from '@kit.BasicServicesKit';
import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { notificationManager } from '@kit.NotificationKit';

export class MyAbility extends UIAbility {
        onWindowStageCreate(windowStage: window.WindowStage) {
                hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
                windowStage.loadContent('pages/Index', (err, data) => {
                        if (err.code) {
                                hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
                                return;
                        }
                        hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
                        let requestEnableNotificationCallback = (err: BusinessError): void => {
                                if (err) {
                                        hilog.error(0x0000, 'testTag', `[ANS] requestEnableNotification failed, code is ${err.code}, message is ${err.message}`);
                                } else {
                                        hilog.info(0x0000, 'testTag', `[ANS] requestEnableNotification success`);
                                }
                        };
                        notificationManager.requestEnableNotification(this.context, requestEnableNotificationCallback);
                });
        }
}
