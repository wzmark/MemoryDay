import reminderAgentManager from '@ohos.reminderAgentManager';
import reminderAgent from '@ohos.reminderAgentManager';
import { EventItem } from '../../model/EventModel';


export class ReminderService {


        public addReminder(event: EventItem, reminderTime: number, callback?: (reminderId: number) => void) {
                let reminder = this.initReminder(event, reminderTime)
                try {
                        reminderAgentManager.publishReminder(reminder, (err, reminderId) => {
                                if (err) {
                                        console.log("callback err code:" + err.code + " message:" + err.message);
                                } else {
                                        console.log("callback, reminderId = " + reminderId);
                                }
                        });
                } catch (error) {
                        console.log("publishReminder code:" + error.code + " message:" + error.message);
                };


        }

        private initReminder(event: EventItem, reminderTime: number): reminderAgent.ReminderRequestCalendar {
                let eventTime = new Date(event.date)
                let content = "已经度过了"
                let reminderRequestCalendar: reminderAgentManager.ReminderRequestCalendar = {
                        dateTime: {year: eventTime.getFullYear(), month: (eventTime.getMonth() + 1), day: (eventTime.getDate()), hour: reminderTime, minute: 0},
                        reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_TIMER,
                        content: content
                }
                return reminderRequestCalendar;
        }


}
