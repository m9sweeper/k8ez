from django.shortcuts import render
from django.http import JsonResponse
import logging

# Create your views here.

logger = logging.getLogger('django.server')

def hello(request):
  data = { "message": "Hello from Django!"}
  logger.info('hello world !!!!......')
  return JsonResponse(data)

