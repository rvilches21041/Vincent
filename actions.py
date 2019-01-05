# -*- coding: utf-8 -*-
import logging
import json
from flask import jsonify
from datetime import datetime
from typing import Text, Dict, Any, List

from rasa_core_sdk import Action, Tracker
from rasa_core_sdk.executor import CollectingDispatcher
from rasa_core_sdk.forms import FormAction
from rasa_core_sdk.events import SlotSet, UserUtteranceReverted, \
    ConversationPaused, FollowupAction, Form

logger = logging.getLogger(__name__)

logging.basicConfig(filename='example.log',level=logging.DEBUG)

class ActionGetBecas(Action):
    def name(self):
        # define the name of the action which can then be included in training stories
        return "action_getBecas"

    def run(self, dispatcher, tracker, domain):
        logging.info(tracker.latest_message)
        print('TRACKER')
        
        entities = tracker.latest_message.get('entities')

        if len(entities) == 0:
            dispatcher.utter_message('Actualmente la utem tiene las siguientes becas: ayudas eventuales, deporte y tu mamita') #send the message back to the user
        else:
            dispatcher.utter_message('hola miamor')
        return []
